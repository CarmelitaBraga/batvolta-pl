% :- module(CaronaLogic,
%         [
%             possui_carona_origem_destino/2
%         ]).

:- use_module('src/Schemas/CsvModule.pl').
% consult('Schemas/CsvModule.pl').

% Définir le chemin du fichier CSV comme une variable globale
csv_file('database/caronas.csv').

% possui_carona_origem_destino(Origem, Destino):-
%     csv_file(File),
%     read_csv_row_by_list_element(File, 4, Trajeto, Row),
%     write(Trajeto), nl,
%     write(Row), nl,
%     split_string(Trajeto, ";", "", ListaTrajeto),
%     sublist([Origem, Destino], ListaTrajeto).

% Predicate to check if a route exists from Origem to Destino
possui_carona_origem_destino(Origem, Destino):-
    read_csv_row_by_list_element('database/caronas.csv', 4, Origem, Rows),
    member(row(_, _, _, Trajeto, _, _, _, _, _, _), Rows),
    split_string(Trajeto, ";", "", ListaTrajeto),
    ordered_pair_in_list([Origem, Destino], ListaTrajeto).


% Helper predicate to check if a list is a sublist of another list
sublist(Sublist, List) :-
    append(_, Rest, List),
    append(Sublist, _, Rest).

% mostra_carona_origem_destino(Origem, Destino, CorrespondingRows):-
%     read_csv_row_by_list_element('database/caronas.csv', 4, Origem, Rows),
%     findall(Row, (member(Row, Rows), row(_, _, _, Trajeto, _, _, _, _, _, _) = Row, split_string(Trajeto, ";", "", ListaTrajeto), sublist([Origem, Destino], ListaTrajeto)), CorrespondingRows).

% Helper predicate to check if two elements exist in a list in the given order
ordered_pair_in_list([X,Y], [X|T]) :-
    member(Y, T).
ordered_pair_in_list(Pair, [_|T]) :-
    ordered_pair_in_list(Pair, T).

% Predicate to check if a route exists from Origem to Destino and return all corresponding rows
mostra_carona_origem_destino(Origem, Destino, CorrespondingRows):-
    read_csv_row_by_list_element('database/caronas.csv', 4, Origem, Rows),
    findall(Row, (member(Row, Rows), row(_, _, _, Trajeto, _, _, _, _, _, _) = Row, split_string(Trajeto, ";", "", ListaTrajeto), ordered_pair_in_list([Origem, Destino], ListaTrajeto)), CorrespondingRows).
