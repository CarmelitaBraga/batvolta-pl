:- module(_, [
    read_csv_row/4,
    read_csv_row_by_list_element/4,
    update_csv_row/4,
    write_csv_row/2,
    write_csv_row_all_steps/2,
    delete_csv_row_bool/3,
    delete_csv_row/3,
    getAllRows/2
    ]).

:- use_module(library(csv)).
:- use_module(library(lists)).
:- use_module('../Util/Utils.pl').

select_row([], _, _, []).
select_row([Row|Rest], Column, Value, [Row|NewRest]) :-
    arg(Column, Row, ArgValue),
    ArgValue \= Value, !,
    select_row(Rest, Column, Value, NewRest).
select_row([_|Rest], Column, Value, NewRest) :-
    select_row(Rest, Column, Value, NewRest).

% Motorista
% select_row([], _, _, []).
% select_row([Row|Rest], Column, Value, [Row|NewRest]) :-
%     arg(Column, Row, Value), !,
%     select_row(Rest, Column, Value, NewRest).
% select_row([_|Rest], Column, Value, NewRest) :-
%     select_row(Rest, Column, Value, NewRest).

% Create or Append
write_csv_row(File, Data) :-
    (exists_file(File) -> 
        open(File, append, Stream),
        csv_write_stream(Stream, Data, []),
        close(Stream)
    ;
        csv_write_file(File, Data)
    ).
% ?- write_csv('database/caronas.csv', [row(1,233,4,'5g','gtgt','gdg','bt')]).

% Create or Append
write_csv_row_all_steps(File, Data) :-
    maplist(parseElement, Data, ParsedList), 
    listToRow(ParsedList, Row),
    (exists_file(File) -> 
        open(File, append, Stream),
        csv_write_stream(Stream, [Row], []),
        close(Stream)
    ;
        csv_write_file(File, [Row])
    ).

% Read a specific row
read_csv_row(File, Column, Value, Row) :-
    csv_read_file(File, Data),
    select_row_read(Data, Column, Value, Row).

select_row_read([], _, _, []).
select_row_read([Row|Rest], Column, Value, [Row|NewRest]) :-
    arg(Column, Row, ArgValue),
    ArgValue == Value, !,
    select_row_read(Rest, Column, Value, NewRest).
select_row_read([_|Rest], Column, Value, NewRest) :-
    select_row_read(Rest, Column, Value, NewRest).

% Update a specific row
update_csv_row(File, Column, Value, UpdatedRow) :-
    csv_read_file(File, Data),
    select_row(Data, Column, Value, DataWithoutOldRow),
    append(DataWithoutOldRow, [UpdatedRow], UpdatedData),
    open(File, write, Stream),
    csv_write_stream(Stream, UpdatedData, []),
    close(Stream).
row_to_list(row(Row), Row).

% Motorista
% Update a specific row
% update_csv_row(File, Column, Value, UpdatedRow) :-
%     read_csv_row(File, Column, Value, Data),
%     select_row(Data, Column, Value, DataWithoutOldRow),
%     append(DataWithoutOldRow, [UpdatedRow], UpdatedData),
%     csv_write_file(File, UpdatedData).

% Delete a specific row
delete_csv_row_bool(File, Column, Value) :-
    csv_read_file(File, Data),
    select_row_delete(Data, Column, Value, DataWithoutRow),
    csv_write_file(File, DataWithoutRow).

select_row_delete([Row|Rest], Column, Value, Rest) :-
    arg(Column, Row, Value), !.
select_row_delete([Row|Rest], Column, Value, [Row|NewRest]) :-
    select_row_delete(Rest, Column, Value, NewRest).

% % Motorista
% delete_csv_row(File, Column, Value) :-
%     csv_read_file(File, Data),
%     select_row_delete(Data, Column, Value, DataWithoutRow),
%     csv_write_file(File, DataWithoutRow).

% % Helper predicate to check if an element exists in a list
% element_in_list(Element, List) :-
%     split_string(List, ";", "", ListItems),
%     member(Element, ListItems).

% % Main predicate to select rows
% select_row_by_list_element([], _, _, []).
% select_row_by_list_element([Row|Rest], Column, Element, [Row|NewRest]) :-
%     arg(Column, Row, Value),
%     element_in_list(Element, Value), !,
%     select_row_by_list_element(Rest, Column, Element, NewRest).
% select_row_by_list_element([_|Rest], Column, Element, NewRest) :-
%     select_row_by_list_element(Rest, Column, Element, NewRest).

% read_csv_row_by_list_element(File, Column, Element, Row) :-
%     csv_read_file(File, Data),
%     select_row_by_list_element(Data, Column, Element, Row).

% Delete a specific row
delete_csv_row(File, Column, Value) :-
    csv_read_file(File, Data),
    select_row(Data, Column, Value, DataWithoutRow),
    csv_write_file(File, DataWithoutRow).

read_csv_row_by_list_element(File, Column, Element, Row) :-
    csv_read_file(File, Data),
    select_row_by_list_element(Data, Column, Element, Row).

split_string_into_list(String, List) :-
    split_string(String, ";", "", List).

element_in_list(Element, ListString) :-
    atom_string(ListString, ListStringText),
    split_string_into_list(ListStringText, List),
    member(Element, List).

select_row_by_list_element([], _, _, []).
select_row_by_list_element([Row|Rest], Column, Element, [Row|NewRest]) :-
    arg(Column, Row, Value),
    atom_string(Value, ValueText),
    element_in_list(Element, ValueText), !,
    select_row_by_list_element(Rest, Column, Element, NewRest).
select_row_by_list_element([_|Rest], Column, Element, NewRest) :-
    select_row_by_list_element(Rest, Column, Element, NewRest).

getAllRows(File, Rows) :-
    csv_read_file(File, Rows).