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
% csv_file('/database/caronas.csv').
carona_column(1).
hora_column(2).
data_column(3).
csv_file('../../database/caronas.csv').
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

remover_passageiro(IdCarona, PassageiroCpf):-
    csv_file(File),
    carona_column(Carona_Column),
    passageiros_column(Pass_Column),
    read_csv_row_by_list_element(File, Pass_Column, PassageiroCpf, Caronas),
    member(row(IdCarona, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao), Caronas),
    (Caronas == [] ->
        write('Nenhuma carona correspondente a passageiro encontrada!'),
        UpdatedRow = row(IdCarona, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao)
    ;  
        atom_string(Passageiros, PassageirosString),
        split_string(PassageirosString, ";", "", PassageirosList),
        delete(PassageirosList, PassageiroCpf, UpdatedPassageirosList),
        atomics_to_string(UpdatedPassageirosList, ";", UpdatedPassageiros),
        UpdatedRow = row(IdCarona, Hora, Data, Rota, MotoristaCpf, UpdatedPassageiros, Valor, Status, Vagas, Avaliacao)    ),
        update_csv_row(File, Carona_Column, IdCarona, UpdatedRow),
        write('Passageiro removido com sucesso!').

% remover_passageiro(2,"11221122112", R).

% solicitar_carona_passageiro/5,
% solicitaParticiparCarona :: Int -> String -> String -> String -> IO String
% solicitaParticiparCarona idCarona idPassageiro origem destino = do
%     -- checar se tem rota
%     -- checar se tem lugar
%     -- checar se tem carona
%     -- checar se o passageiro ja esta
%     maybeCarona <- getCaronaById [idCarona]
%     if null maybeCarona
%         then return "Carona inexistente!"
%         else do
%             let carona = head maybeCarona
%                 rota = getCaminho carona origem destino
%             if null rota
%                 then return "Essa carona não possui essa rota!"
%                 else do
%                     let mensagem = "O Passageiro: " ++ idPassageiro ++ " solicitou entrar na corrida de id: " ++ show idCarona
%                     insereNotificacao (motorista carona) idPassageiro idCarona mensagem
%                     criarViagemPassageiro idCarona False (getCaminho carona origem destino) 0 idPassageiro
%                     return "Registro de Passageiro em Carona criado com sucesso!"

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