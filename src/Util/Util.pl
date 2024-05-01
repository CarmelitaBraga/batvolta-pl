:- module(_,[
    nullOrEmpty/1,
    validarCPF/1,
    validarEmail/1,
    validaRegiao/1,
    validarGenero/1,
    valida_senha/1,
    list_to_string/3
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

% Predicado para validar senha
valida_senha(Senha) :-
    string_length(Senha, Tamanho),
    Tamanho >= 4,  % Senha deve ter pelo menos tamanho 4
    conta_letras(Senha, Letras),
    Letras >= 1.   % Senha deve conter pelo menos uma letra

% Predicado auxiliar para contar letras na senha
conta_letras(Senha, Letras) :-
    string_chars(Senha, Chars),
    include(alpha, Chars, LetrasChars),
    length(LetrasChars, Letras).

% Predicado para verificar se um caractere é alfabético
alpha(Char) :-
    char_type(Char, alpha).

list_to_string([], Str, Str).
list_to_string([H|T], Str, R) :-
    string_concat(Str, H, TempStr),
    string_concat(TempStr,'\n',NovaStr),
    list_to_string(T, NovaStr, R).