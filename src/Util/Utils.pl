:- module(_, [
    parseElement/2,
    insertAtFirst/3,
    listToRow/2,
    list_to_string/3,
    printList/1,
    take_evaluations_decrescent/3,
    sort_tuples/2,
    extract_names/2,
    take_n/3
    ]).

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

% Predicate to compare second elements of two tuples
compare_tuples(Order, (_, X), (_, Y)) :-
    (   X < Y -> Order = >
    ;   X > Y -> Order = <
    ;   Order = <
    ).

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
    

extract_names([], []).
extract_names([(Name, _)|T], [Name|Rest]) :-
    
    extract_names(T, Rest).





extract_names([], []).
extract_names([[Name, _]|T], [Name|Rest]) :-
    extract_names(T, Rest).

% Input: [("Quebec", 2),  ("Rio", 2),  ("Gramado", 2),  ("Minas", 1),  ("Sao Paulo", 1)]
% Output: ["Quebec", "Rio", "Gramado", "Minas", "Sao Paulo"]
extract_names([(Name, _)|T], [Name|Rest]) :-
    extract_names(T, Rest).