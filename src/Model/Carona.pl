:- use_module(library(csv)).

% Facts
statusCarona(naoIniciada).
statusCarona(emAndamento).
statusCarona(finalizada).

% carona(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros).

% Define a predicate for creating carona terms
carona(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros) :-
    % Add any necessary constraints on the arguments here, if needed
    Cid =.. [cid|_],
    Hora =.. [hora|_],
    Date =.. [date|_],
    Destinos =.. [destinos|_],
    Motorista =.. [motorista|_],
    Passageiros =.. [passageiros|_],
    Valor =.. [valor|_],
    member(Status, [emAndamento, naoIniciada, finalizada]),
    NumPassageirosMaximos =.. [numPassageirosMaximos|_],
    AvaliacaoPassageiros =.. [avaliacaoPassageiros|_].

caronaToStr(carona(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros), Str) :-
    % Convert list of destinations to string
    list_to_string(Destinos, DestinosStr),
    list_to_string(Passageiros, PassageirosStr),
    % Concatenate all values into a string
    atomic_list_concat([Cid, Hora, Date, DestinosStr, Motorista, PassageirosStr, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros], ',', Str).

% Define a predicate to convert list to string
list_to_string([], '').
list_to_string([H|T], Str) :-
    list_to_string(T, Rest),
    (   Rest = '' ->  % Check if the rest is empty
        atomic_list_concat([H], ',', Str)
    ;   atomic_list_concat([H, Rest], ',', Str)
    ).

% assert_carona_fact(row(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros)) :-
%     assertz(carona(cid(Cid), hora(Hora), date(Date), destinos(Destinos), motorista(Motorista), passageiros(Passageiros), valor(Valor), status(Status), numPassageirosMaximos(NumPassageirosMaximos), avaliacaoPassageiros(AvaliacaoPassageiros))).

% load_carona_facts(File) :-
%     csv_read_file(File, Rows, []),
%     maplist(assert_carona_fact, Rows).

assert_carona_fact(row(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros)) :-
    assertz(carona_fact(cid(Cid), hora(Hora), date(Date), destinos(Destinos), motorista(Motorista), passageiros(Passageiros), valor(Valor), status(Status), numPassageirosMaximos(NumPassageirosMaximos), avaliacaoPassageiros(AvaliacaoPassageiros))).

load_carona_facts(File) :-
    csv_read_file(File, Rows, []),
    maplist(assert_carona_fact, Rows).
