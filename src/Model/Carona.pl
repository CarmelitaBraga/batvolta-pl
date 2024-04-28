:- module(_, [caronaToStr/2]).

:- use_module(library(csv)).

% Facts
statusCarona(naoIniciada).
statusCarona(emAndamento).
statusCarona(finalizada).

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

% % Define a predicate to convert list to string
% list_to_string([], '').
% list_to_string([H|T], Str) :-
%     list_to_string(T, Rest),
%     (   Rest = '' ->  % Check if the rest is empty
%         atomic_list_concat([H], ',', Str)
%     ;   atomic_list_concat([H, Rest], ',', Str)
%     ).

assert_carona_fact(row(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros)) :-
    assertz(carona_fact(cid(Cid), hora(Hora), date(Date), destinos(Destinos), motorista(Motorista), passageiros(Passageiros), valor(Valor), status(Status), numPassageirosMaximos(NumPassageirosMaximos), avaliacaoPassageiros(AvaliacaoPassageiros))).

load_carona_facts(File) :-
    csv_read_file(File, Rows, []),
    maplist(assert_carona_fact, Rows).

% Predicate to convert a row to a string
caronaToStr(row(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros), Str) :-
    % Format each field
    format(string(CidStr), "Carona ID: ~w", [Cid]),
    format(string(HoraStr), "Hora: ~w", [Hora]),
    format(string(DateStr), "Date: ~w", [Date]),
    format(string(DestinosStr), "Destinos: ~w", [Destinos]),
    format(string(MotoristaStr), "Motorista: ~w", [Motorista]),
    format(string(PassageirosStr), "Passageiros: ~w", [Passageiros]),
    format(string(ValorStr), "Valor: ~w", [Valor]),
    format(string(StatusStr), "Status: ~w", [Status]),
    format(string(NumPassageirosMaximosStr), "Número Máximo de Passageiros: ~w", [NumPassageirosMaximos]),
    format(string(AvaliacaoPassageirosStr), "Avaliação dos Passageiros: ~w", [AvaliacaoPassageiros]),
    % Concatenate all formatted fields into a string
    atomic_list_concat([CidStr, HoraStr, DateStr, DestinosStr, MotoristaStr, PassageirosStr, ValorStr, StatusStr, NumPassageirosMaximosStr, AvaliacaoPassageirosStr], ', ', Str).

