:- module(_, [
    parseElement/2,
    insertAtFirst/3,
    listToRow/2,
    list_to_string/3
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