:- use_module(library(csv)).

% Helper predicate to select a row based on a column value
select_row([Row|Rest], Column, Value, Rest) :-
    arg(Column, Row, Value), !.
select_row([Row|Rest], Column, Value, [Row|NewRest]) :-
    select_row(Rest, Column, Value, NewRest).

% Create or Append
write_csv(File, Data) :-
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
update_csv(File, Column, Value, UpdatedRow) :-
    read_csv_row(File, Column, Value, Data),
    select_row(Data, Column, Value, DataWithoutOldRow),
    append(DataWithoutOldRow, [UpdatedRow], UpdatedData),
    csv_write_file(File, UpdatedData).

% Delete a specific row
delete_csv(File, Column, Value) :-
    csv_read_file(File, Data),
    select_row(Data, Column, Value, DataWithoutRow),
    csv_write_file(File, DataWithoutRow).
