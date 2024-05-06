:- module(_, [
    parseElement/2,
    insertAtFirst/3,
    listToRow/2,
    list_to_string/3,
    printList/1,
    take_evaluations_decrescent/3,
    sort_tuples/2,
    extract_names/2,
    take_n/3,
    validar_cpf/1,
    validar_email/1,
    validar_genero/1,
    list_to_atom_list/2,
    ordered_pair_in_list/2,
    validar_senha/1,
    null_or_empty/1,
    validar_regiao/1,
    convert_list_atom/2
    ]).

% Predicado para validar senha
validar_senha(Senha) :-
    string_length(Senha, Tamanho),
    Tamanho >= 4,  % Senha deve ter pelo menos tamanho 4
    conta_letras(Senha, Letras),
    Letras >= 1.   % Senha deve conter pelo menos uma letra

% Predicado auxiliar para contar letras na senha
conta_letras(Senha, Letras) :-
    string_chars(Senha, Chars),
    include(alpha, Chars, LetrasChars),
    length(LetrasChars, Letras).

alpha(Char) :-
    char_type(Char, alpha).

validar_email(Email) :-
    atom_chars(Email, Chars),
    split_string(Email, "@", "", [_Usuario, Dominio]),
    length(Chars, Length),
    Length > 0, % Verifica se a string não está vazia
    atom_length(Dominio, LengthDominio),
    LengthDominio > 0, % Verifica se o domínio não está vazio
    split_string(Dominio, ".", "", [_NomeDominio, Extensao]),
    Extensao \= "". % Verifica se a extensão do domínio não está vazia

parseElement(Element, ParsedElement) :-
    (is_list(Element) ->
        atomic_list_concat(Element, ';', ParsedElement)
    ;   ParsedElement = Element
    ). 

% Auxiliar para inserir na primeira posição de uma lista.
insertAtFirst(ID, List, [ID|List]).

listToRow(Elements, Row) :- Row =.. [row|Elements].

list_to_string([], Str, Str).
list_to_string([H|T], Str, R) :-
    string_concat(Str, H, TempStr),
    string_concat(TempStr,'\n',NovaStr),
    list_to_string(T, NovaStr, R).

printList([]).
printList([H|T]) :-
    writeln(H),
    printList(T).

% Predicate to compare second elements of two tuples
% compare_tuples(Order, (_, X), (_, Y)) :-
%     compare(Order, Y, X).

% Predicate to sort list of tuples by second element in descending order
sort_tuples(List, Sorted) :-
    predsort(compare_tuples, List, Sorted).

% Predicate to take first N elements from a list
take_n(_, [], []).
take_n(N, _, []) :- N =< 0, !.
take_n(N, [H|T], [H|Res]) :-
    N1 is N - 1,
    take_n(N1, T, Res).

% Predicate to take top N evaluations
take_evaluations_decrescent(Amostra, AvaliacoesEntidade, TopAvaliacoes) :-
    sort_tuples(AvaliacoesEntidade, SortedAvaliacoes),
    take_n(Amostra, SortedAvaliacoes, TopAvaliacoes).
    
% Predicate to compare second elements of two tuples
% compare_tuples(Order, (_, X), (_, Y)) :-
%     compare(Order, Y, X).

% Predicate to compare second elements of two tuples
compare_tuples(Order, (_, X), (_, Y)) :-
    (   X < Y -> Order = >
    ;   X > Y -> Order = <
    ;   Order = <
    ).

extract_names([], []).
extract_names([(Name, _)|T], [Name|Rest]) :-
    extract_names(T, Rest).
extract_names([[Name, _]|T], [Name|Rest]) :-
    extract_names(T, Rest).

list_to_atom_list([], []).
list_to_atom_list([H|T], [Atom|AtomList]) :-
    atom_string(Atom, H),
    list_to_atom_list(T, AtomList).

% Helper predicate to check if two elements exist in a list in the given order
ordered_pair_in_list([X,Y], [X|T]) :-
    member(Y, T), !.
ordered_pair_in_list(Pair, [_|T]) :-
    ordered_pair_in_list(Pair, T).

validar_cpf(CPF) :-
    atom_length(CPF, 11), % Verifica se o CPF tem 11 caracteres
    atom_chars(CPF, Chars), % Converte o CPF em uma lista de caracteres
    maplist(char_type, Chars, [digit, digit, digit, digit, digit, digit, digit, digit, digit, digit, digit]). % Verifica se todos os caracteres são dígitos

null_or_empty(Str) :-
    atom_chars(Str, Chars), % Converte a string em uma lista de caracteres
    forall(member(Char, Chars), Char == ' '). % Verifica se todos os caracteres são espaços em branco

generos(['f', 'm', 'nb']).

validar_genero(Genero) :-
    generos(Generos),
    downcase_atom(Genero, Minusculo),
    \+ member(Minusculo, Generos).

regioes_brasil(['norte', 'nordeste', 'centro-oeste', 'sudeste', 'sul']).

validar_regiao(Regiao) :-
    regioes_brasil(Regioes),
    downcase_atom(Regiao, Minusculo),
    \+ member(Minusculo, Regioes).

% Predicado auxiliar para contar letras na senha
conta_letras(Senha, Letras) :-
    string_chars(Senha, Chars),
    include(alpha, Chars, LetrasChars),
    length(LetrasChars, Letras).

% Predicado para verificar se um caractere é alfabético
alpha(Char) :-
    char_type(Char, alpha).

% Predicado para converter um número em um átomo
number_to_atom(Number, Atom) :-
    number_codes(Number, Codes),
    atom_codes(Atom, Codes).

% Predicado para converter uma lista de números em uma lista de átomos
convert_list_atom([], []).
convert_list_atom([H|T], [Atom|Result]) :-
    number(H),  % check if H is a number
    number_to_atom(H, Atom),  % convert H to an atom
    convert_list_atom(T, Result).
convert_list_atom([H|T], [H|Result]) :-
    \+ number(H),  % H is not a number, leave it unchanged
    convert_list_atom(T, Result).