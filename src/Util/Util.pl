:- module(_,[
    nullOrEmpty/1,
    validarCPF/1,
    validarEmail/1,
    validaRegiao/1,
    validarGenero/1
]).

validarCPF(CPF) :-
    atom_length(CPF, 11), % Verifica se o CPF tem 11 caracteres
    atom_chars(CPF, Chars), % Converte o CPF em uma lista de caracteres
    maplist(char_type, Chars, [digit, digit, digit, digit, digit, digit, digit, digit, digit, digit, digit]). % Verifica se todos os caracteres são dígitos

nullOrEmpty(Str) :-
    atom_chars(Str, Chars), % Converte a string em uma lista de caracteres
    forall(member(Char, Chars), Char == ' '). % Verifica se todos os caracteres são espaços em branco

validarEmail(Email) :-
    atom_chars(Email, Chars),
    split_string(Email, "@", "", [_Usuario, Dominio]),
    length(Chars, Length),
    Length > 0, % Verifica se a string não está vazia
    atom_length(Dominio, LengthDominio),
    LengthDominio > 0, % Verifica se o domínio não está vazio
    split_string(Dominio, ".", "", [_NomeDominio, Extensao]),
    Extensao \= "". % Verifica se a extensão do domínio não está vazia

generos(['f', 'm', 'nb']).

validarGenero(Genero) :-
    generos(Generos),
    downcase_atom(Genero, Minusculo),
    \+ member(Minusculo, Generos).

regioes_brasil(['norte', 'nordeste', 'centro-oeste', 'sudeste', 'sul']).

validaRegiao(Regiao) :-
    regioes_brasil(Regioes),
    downcase_atom(Regiao, Minusculo),
    \+ member(Minusculo, Regioes).
