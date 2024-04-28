:- module(_, [read_csv_row/4]).

:- use_module(library(csv)).


select_row([], _, _, []).
select_row([Row|Rest], Column, Value, [Row|NewRest]) :-
    arg(Column, Row, Value), !,
    select_row(Rest, Column, Value, NewRest).
select_row([_|Rest], Column, Value, NewRest) :-
    select_row(Rest, Column, Value, NewRest).

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

% Read a specific row
read_csv_row(File, Column, Value, Row) :-
    csv_read_file(File, Data),
    select_row(Data, Column, Value, Row).

% Update a specific row
update_csv_row(File, Column, Value, UpdatedRow) :-
    read_csv_row(File, Column, Value, Data),
    select_row(Data, Column, Value, DataWithoutOldRow),
    append(DataWithoutOldRow, [UpdatedRow], UpdatedData),
    csv_write_file(File, UpdatedData).

% Delete a specific row
delete_csv_row(File, Column, Value) :-
    csv_read_file(File, Data),
    select_row(Data, Column, Value, DataWithoutRow),
    csv_write_file(File, DataWithoutRow).

% Helper predicate to check if an element exists in a list
element_in_list(Element, List) :-
    split_string(List, ";", "", ListItems),
    member(Element, ListItems).

% Main predicate to select rows
select_row_by_list_element([], _, _, []).
select_row_by_list_element([Row|Rest], Column, Element, [Row|NewRest]) :-
    arg(Column, Row, Value),
    element_in_list(Element, Value), !,
    select_row_by_list_element(Rest, Column, Element, NewRest).
select_row_by_list_element([_|Rest], Column, Element, NewRest) :-
    select_row_by_list_element(Rest, Column, Element, NewRest).

read_csv_row_by_list_element(File, Column, Element, Row) :-
    csv_read_file(File, Data),
    select_row_by_list_element(Data, Column, Element, Row).
