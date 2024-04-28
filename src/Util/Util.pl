:- module(_, [validar_cpf/1]).

validar_cpf(CPF):-
    atom_length(CPF, Length),
    Length = 11.
