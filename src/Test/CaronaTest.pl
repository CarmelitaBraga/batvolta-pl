:- module(_,[]).

:- use_module('src/Controller/CaronaController.pl').

% Définition des assertions
assert_desembarcar_passageiro_1(IdCarona, PassageiroCpf) :-
    desembarcar_passageiro(IdCarona, PassageiroCpf),
    format("'CaronaController':desembarcar_passageiro(~w,\"~w\")", [IdCarona, PassageiroCpf]),
    write(" ? yes"), nl.

assert_desembarcar_passageiro_2(IdCarona, PassageiroCpf) :-
    desembarcar_passageiro(IdCarona, PassageiroCpf),
    format("'CaronaController':desembarcar_passageiro(~w,\"~w\")", [IdCarona, PassageiroCpf]),
    write(" ? yes"), nl,
    write("Passageiro removido com sucesso!").

% Exemples d'utilisation
test_assertions :-
    assert_desembarcar_passageiro_1(2, "11221122112"),
    assert_desembarcar_passageiro_2(0, "11111111111").

% % Assertion pour desembarcar_passageiro/2
% assert_desembarcar_passageiro(IdCarona, PassageiroCpf, ExpectedResult) :-
%     desembarcar_passageiro(IdCarona, PassageiroCpf),
%     (ExpectedResult == true -> 
%         write('Test passed.')
%     ; 
%         write('Test failed.')
%     ).

% % Assertion pour remover_passageiro/2
% assert_remover_passageiro(IdCarona, PassageiroCpf, ExpectedRow) :-
%     remover_passageiro(IdCarona, PassageiroCpf),
%     csv_file(File),
%     carona_column(Carona_Column),
%     read_csv_row(File, Carona_Column, IdCarona, [Row]),
%     (Row == ExpectedRow -> 
%         write('Test passed.')
%     ; 
%         write('Test failed.')
%     ).

% assert_desembarcar_passageiro(IdCarona, PassageiroCpf, ExpectedResult).