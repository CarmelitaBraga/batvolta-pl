:- module(_,[possui_carona_origem_destino/2, mostra_caronas_origem_destino/3]).

:- use_module('src/Schemas/CsvModule.pl').
:- use_module('src/Model/Carona.pl').

% Définir le chemin du fichier CSV comme une variable globale
csv_file('database/caronas.csv').

% Predicate to check if a route exists from Origem to Destino
possui_carona_origem_destino(Origem, Destino):-
    read_csv_row_by_list_element('database/caronas.csv', 4, Origem, Rows),
    member(row(_, _, _, Trajeto, _, _, _, _, _, _), Rows),
    split_string(Trajeto, ";", "", ListaTrajeto),
    ordered_pair_in_list([Origem, Destino], ListaTrajeto).

% Helper predicate to check if two elements exist in a list in the given order
ordered_pair_in_list([X,Y], [X|T]) :-
    member(Y, T).
ordered_pair_in_list(Pair, [_|T]) :-
    ordered_pair_in_list(Pair, T).

mostra_caronas_origem_destino(Origem, Destino, CorrespondingRowsStr):-
    read_csv_row_by_list_element('database/caronas.csv', 4, Origem, Rows),
    findall(Str, (member(Row, Rows), row(_, _, _, Trajeto, _, _, _, _, _, _) = Row, split_string(Trajeto, ";", "", ListaTrajeto), ordered_pair_in_list([Origem, Destino], ListaTrajeto), caronaToStr(Row, Str)), CorrespondingRowsStr).

% Convert all rows in Caronas to strings
caronasToStr(Caronas, Strs) :-
    findall(Str, (member(Carona, Caronas), caronaToStr(Carona, Str)), Strs).

