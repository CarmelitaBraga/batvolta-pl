:- module(_,[
    possui_carona_origem_destino/2, 
    mostrar_caronas_origem_destino/3, 
    mostrar_caronas_passageiro_participa/2,
    remover_passageiro/2
    % embarcar_passageiro_carona/2
    ]).

:- use_module('src/Schemas/CsvModule.pl').
:- use_module('src/Model/Carona.pl').

% Définir le chemin du fichier CSV comme une variable globale
csv_file('database/caronas.csv').
carona_column(1).
hora_column(2).
data_column(3).
destinos_column(4).
motorista_column(5).
passageiros_column(6).
valor_column(7).
status_column(8).
lim_pass_column(9).
avaliacao_column(10).

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

