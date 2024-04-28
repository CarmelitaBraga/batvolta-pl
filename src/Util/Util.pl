:- module(_, [validar_cpf/1, null_or_empty/1, validar_email/1, validar_genero/1]).

validar_cpf(CPF):-
    atom_length(CPF, Length),
    Length = 11.

% n sei se é gambiarra
null_or_empty(STRING):-
    atom_length(STRING, Length),
    Length = 0.

validar_email(Email) :-
    atom_chars(Email, Chars),
    split_string(Email, "@", "", [_Usuario, Dominio]),
    length(Chars, Length),
    Length > 0, % Verifica se a string não está vazia
    atom_length(Dominio, LengthDominio),
    LengthDominio > 0, % Verifica se o domínio não está vazio
    split_string(Dominio, ".", "", [_NomeDominio, Extensao]),
    Extensao \= "". % Verifica se a extensão do domínio não está vazia

validar_genero(Genero):- 
    Genero = "M"; Genero = "F"; Genero = "NB".

    

