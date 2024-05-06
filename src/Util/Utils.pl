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
    null_or_empty/1,
    validar_email/1,
    validar_genero/1,
    list_to_atom_list/2,
    ordered_pair_in_list/2
    ]).

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
    Genero = 'M'; Genero = 'F'; Genero = 'NB'.

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
