:- module(_,[
    possui_carona_origem_destino/2, 
    mostra_caronas_origem_destino/3, 
    mostrar_caronas_passageiro_participa/2,
    criar_carona_motorista/6
    ]).

:- use_module('../Schemas/CsvModule.pl').
:- use_module('../Model/Carona.pl').

% Définir le chemin du fichier CSV comme une variable globale
csv_file('../../database/caronas.csv').
destinos_column(4).
passageiros_column(6).

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

mostra_caronas_origem_destino(Origem, Destino, CorrespondingRowsStr):-
    csv_file(File),
    destinos_column(Dest_column),
    read_csv_row_by_list_element(File, Dest_column, Origem, Rows),
    findall(Str, (member(Row, Rows), row(_, _, _, Trajeto, _, _, _, _, _, _) = Row, split_string(Trajeto, ";", "", ListaTrajeto), ordered_pair_in_list([Origem, Destino], ListaTrajeto), caronaToStr(Row, Str)), CorrespondingRowsStr).

% Convert all rows in Caronas to strings
% caronasToStr(Caronas, Strs) :-
%     findall(Str, (member(Carona, Caronas), caronaToStr(Carona, Str)), Strs).

% mostrar_caronas_passageiro/2,
% cancelar_carona_passageiro/2,
% embarcar_passageiro/2,
% desembarcar_passageiro/2,
% mostrar_viagem_passageiro/2,
% get_viagem_sem_avaliacao/2,
% solicitar_carona_passageiro/5,
% avaliar_motorista/4

mostrar_caronas_passageiro_participa(PassageiroCpf, CaronasStr):-
    csv_file(File),
    passageiros_column(Pass_Column),
    read_csv_row_by_list_element(File, Pass_Column, PassageiroCpf, Rows),
    findall(Str, (member(Row, Rows), caronaToStr(Row, Str)), CaronasStr).

criar_carona_motorista(Hora, Data, Destinos, MotoristaCpf, Valor, NumPassageirosMaximos) :-
    csv_file(CsvFile),
    id(ID),
    Carona = carona(ID, Hora, Data, Destinos, MotoristaCpf, [], Valor, naoIniciada, NumPassageirosMaximos, -1),
    incrementa_id,
    % Converte a instância de Carona em uma lista
    carona_to_list(Carona, ListaCarona),
    % Escreve a linha no arquivo CSV
    write_csv_row_all_steps(CsvFile, ListaCarona).
    
