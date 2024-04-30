:- module(_,[
    possui_carona_origem_destino/2,
    mostrar_caronas_origem_destino/3, 
    mostrar_caronas_passageiro_participa/2,
    remover_passageiro/2,
    criar_carona_motorista/6,
    % embarcar_passageiro_carona/2
    iniciar_carona_status/1,
    finalizar_carona_status/1,
    cancelar_carona/1
    ]).

:- use_module('../Schemas/CsvModule.pl').
:- use_module('../Model/Carona.pl').

% Définir le chemin du fichier CSV comme une variable globale
csv_file('database/caronas.csv').
carona_column(1).
hora_column(2).
data_column(3).
% csv_file('../../database/caronas.csv').
destinos_column(4).
motorista_column(5).
passageiros_column(6).
valor_column(7).
status_column(8).
lim_pass_column(9).
avaliacao_column(10).

% Fato dinâmico para gerar o id das caronas
id(0).
incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
:- dynamic id/1.

% Predicate to check if a route exists from Origem to Destino
possui_carona_origem_destino(Origem, Destino):-
    csv_file(File),
    destinos_column(Dest_column),
    read_csv_row_by_list_element(File, Dest_column, Origem, Rows),
    member(row(_, _, _, Trajeto, _, _, _, _, _, _), Rows),
    split_string(Trajeto, ";", "", ListaTrajeto),
    ordered_pair_in_list([Origem, Destino], ListaTrajeto).

% Helper predicate to check if two elements exist in a list in the given order
ordered_pair_in_list([X,Y], [X|T]) :-
    member(Y, T).
ordered_pair_in_list(Pair, [_|T]) :-
    ordered_pair_in_list(Pair, T).

mostrar_caronas_origem_destino(Origem, Destino, CorrespondingRowsStr):-
    csv_file(File),
    destinos_column(Dest_column),
    read_csv_row_by_list_element(File, Dest_column, Origem, Rows),
    findall(Str, (member(Row, Rows), row(_, _, _, Trajeto, _, _, _, _, _, _) = Row, split_string(Trajeto, ";", "", ListaTrajeto), ordered_pair_in_list([Origem, Destino], ListaTrajeto), caronaToStr(Row, Str)), CorrespondingRowsStr).
% mostrar_caronas_passageiro_participa("11221122112", Str).

mostrar_caronas_passageiro_participa(PassageiroCpf, CaronasStr):-
    csv_file(File),
    passageiros_column(Pass_Column),
    read_csv_row_by_list_element(File, Pass_Column, PassageiroCpf, Rows),
    findall(Str, (member(Row, Rows), caronaToStr(Row, Str)), CaronasStr).

% embarcar_passageiro_carona(IdCarona, PassageiroCpf):-
%     csv_file(File),
%     carona_column(Carona_Column),
%     passageiros_column(Pass_Column),
    % verificar se carona existe
    % verificar se carona tem espaço
    % verificar se passageiro existe
% .

% adicionarPassageiro :: Int -> String -> IO String
% adicionarPassageiro caronaId passageiro = do
%     maybeCarona <- getCaronaById [caronaId]
%     case maybeCarona of
%         [] -> return "Essa carona não existe!"
%         [carona] -> do
%             teste <- infoTrechoByCaronaPassageiro caronaId passageiro
%             if teste /= "Trecho de carona inexistente para o passageiro informado!" then do
%                 if status carona == read "EmAndamento" then do
%                     viagem <- getViagemByCaronaPassageiro caronaId passageiro
%                     if aceita (head viagem) then do
%                         bool <- lugaresDisponiveis carona
%                         if bool then do
%                             caronaAtualizada <- addPassageiro carona passageiro
%                             return "Passageiro adicionado com sucesso!"

%                         else if numPassageirosMaximos carona == 1
%                             then return "Carona sem vagas!"
%                             else return "Carona já está cheia!"
%                     else do
%                         return "Você não foi aceito nesta carona!"
%                 else do
%                     return "Carona nao iniciada ou ja finalizada!"
%             else do 
%                 return "Passageiro não está nessa carona."


remover_passageiro(IdCarona, PassageiroCpf):-
    csv_file(File),
    carona_column(Carona_Column),
    passageiros_column(Pass_Column),
    read_csv_row_by_list_element(File, Pass_Column, PassageiroCpf, Caronas),
    (member(row(IdCarona, _, _, _, _, _, _, _, _, _), Caronas) ->
        member(row(IdCarona, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao), Caronas),
        atom_string(Passageiros, PassageirosString),
        split_string(PassageirosString, ";", "", PassageirosList),
        delete(PassageirosList, PassageiroCpf, UpdatedPassageirosList),
        atomics_to_string(UpdatedPassageirosList, ";", UpdatedPassageiros),
        UpdatedRow = row(IdCarona, Hora, Data, Rota, MotoristaCpf, UpdatedPassageiros, Valor, Status, Vagas, Avaliacao),
        update_csv_row(File, Carona_Column, IdCarona, UpdatedRow),
        write('Passageiro removido com sucesso!')
    ;
        write('Nenhuma carona correspondente a passageiro encontrada!'),
        _ = row(_, _, _, _, _, _, _, _, _, _)
    ).
% remover_passageiro(2,"11221122112", R).

% TODO: debbugar
solicitar_participar_carona(IdCarona, PassageiroCpf, Origem, Destino, Resp):-
    csv_file(File),
    carona_column(Carona_Column),
    (possui_carona_origem_destino(Origem, Destino) ->
        read_csv_row_by_list_element(File, Carona_Column, IdCarona, Caronas),
        (member(row(IdCarona, _, _, _, Motorista, Passageiros, _, Status, Limite_Vagas, _), Caronas) ->
            split_string(Passageiros, ";", "", ListaPassageiros),
            length(ListaPassageiros, QtdPass),
            number_string(PassageiroCpf, PassageiroStr),  % Convert PassageiroCpf to a string
            (QtdPass == Limite_Vagas, \+ member(PassageiroStr, ListaPassageiros) ->
                Resp = 'Carona com capacidade máxima de passageiros!'
            ;
                format(string(Rota), "~w;~w", [Origem, Destino]),  % Corrected string formatting
                format(string(Mensagem), "O Passageiro: ~w solicitou entrar na corrida de id: ~w", [PassageiroCpf, IdCarona]),  % Corrected format/2 usage
                % insere_notificacao(Motorista, PassageiroCpf, IdCarona, Mensagem),
                criar_viagem_passageiro(IdCarona, "False", Rota, 0, PassageiroCpf),
                Resp = 'Registro de passageiro em carona criado com sucesso!'
            )
        ;
            Resp = 'Carona inexistente!'
        )
    ;
        Resp = 'Rota não encontrada!'
    ).

% solicitar_participar_carona(IdCarona, PassageiroCpf, Origem, Destino, Resp):-
%     csv_file(File),
%     carona_column(Carona_Column),
%     (possui_carona_origem_destino(Origem, Destino) ->
%         read_csv_row_by_list_element(File, Carona_Column, IdCarona, Caronas),
%         (member(row(IdCarona, _, _, _, Motorista, Passageiros, _, Status, Limite_Vagas, _), Caronas) ->
%             split_string(Passageiros, ";", "", ListaPassageiros),
%             length(ListaPassageiros, QtdPass),
%             (QtdPass == Limite_Vagas, \+ member(ListaPassageiros, PassageiroCpf) ->
%                 Resp = 'Carona com capacidade máxima de passageiros!'
%             ;
%                 format((Mensagem), "O Passageiro: ~w solicitou entrar na corrida de id:" [PassageiroCpf, IdCarona]),
%                 % insere_notificacao(Motorista, PassageiroCpf, IdCarona, Mensagem),
%                 criar_viagem_passageiro(IdCarona, "False", "~w;~w"[Origem,Destino], 0, PassageiroCpf),
%               Resp = 'Registro de passageiro em carona criado com sucesso!'
%             )
%         ;
%             Resp = 'Carona inexistente!'
%         )
%     ;
%         Resp = 'Rota não encontrada!'
%     )
% .


criar_carona_motorista(Hora, Data, Destinos, MotoristaCpf, Valor, NumPassageirosMaximos) :-
    csv_file(CsvFile),
    id(ID),
    Carona = carona(ID, Hora, Data, Destinos, MotoristaCpf, [], Valor, naoIniciada, NumPassageirosMaximos, -1),
    incrementa_id,
    % Converte a instância de Carona em uma lista
    carona_to_list(Carona, ListaCarona),
    % Escreve a linha no arquivo CSV
    write_csv_row_all_steps(CsvFile, ListaCarona).
    
iniciar_carona_status(Cid) :-
    csv_file(File),
    carona_column(CaronaColumn),
    read_csv_row(File, CaronaColumn , Cid, Caronas),
    (Caronas == [] ->
        write('Nenhuma carona correspondente a esse ID foi encontrada!')
    ;
        member(row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao), Caronas),
        (Status == naoIniciada ->
            UpdatedRow = row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, emAndamento, Vagas, Avaliacao),
            update_csv_row(File, CaronaColumn, Cid, UpdatedRow)
            ;
            write('Essa carona não pode ser iniciada!')
        )
    ).
        
finalizar_carona_status(Cid) :-
    csv_file(File),
    carona_column(CaronaColumn),
    read_csv_row(File, CaronaColumn , Cid, Caronas),
    (Caronas == [] ->
        write('Nenhuma carona correspondente a esse ID foi encontrada!')
    ;
        member(row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao), Caronas),
        (Status == emAndamento ->
            UpdatedRow = row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, finalizada, Vagas, Avaliacao),
            update_csv_row(File, CaronaColumn, Cid, UpdatedRow)
            ;
            write('Essa carona não pode ser finalizada!')
        )
    ).

cancelar_carona(Cid) :-
    csv_file(File),
    carona_column(CaronaColumn),
    read_csv_row(File, CaronaColumn , Cid, Caronas),
    (Caronas == [] ->
        write('Nenhuma carona correspondente a esse ID foi encontrada!')
    ;
        member(row(Cid, _, _, _, _, _, _, Status, _, _), Caronas),
        (\+ Status == naoIniciada ->
            write('Essa carona nao pode ser cancelada!')
            ;
            delete_csv_row(File,CaronaColumn, Cid),
            write('Carona deletada com sucesso!')
        )
    ).