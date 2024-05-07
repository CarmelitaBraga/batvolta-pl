:- module(_, [viagemToStr/2, passageiroViagem/6, viagem_to_list/2]).

:- use_module(library(csv)).

% Define a predicate for creating carona terms
passageiroViagem(ViagemId, CaronaId, Aceito, Rota, Avaliacao, PassageiroCpf):-
    % Add any necessary constraints on the arguments here, if needed
    ViagemId =.. [viagemId|_],
    CaronaId =.. [caronaId|_],
    Aceito =.. [aceito|_],
    Rota =.. [rota|_],
    Avaliacao =.. [avaliacao|_],
    PassageiroCpf =.. [passageiro|_].

% Predicate to convert a row to a string
viagemToStr(row(ViagemId, CaronaId, Aceito, Rota, Avaliacao, PassageiroCpf), Str) :-
    % Format each field
    format(string(ViagemIdStr), "Viagem ID: ~w", [ViagemId]),
    format(string(CaronaIdStr), "Carona ID: ~w", [CaronaId]),
    format(string(AceitoStr), "Aceito: ~w", [Aceito]),
    format(string(RotaStr), "Rota: ~w", [Rota]),
    format(string(AvaliacaoStr), "Avaliacao: ~w", [Avaliacao]),
    format(string(PassageiroCpfStr), "Passageiro CPF: ~w", [PassageiroCpf]),
    % Concatenate all formatted fields into a string
    atomic_list_concat([ViagemIdStr, CaronaIdStr, AceitoStr, RotaStr, AvaliacaoStr, PassageiroCpfStr], ', ', Str).

% Predicate to convert a passageiroViagem instance into a list of its arguments
viagem_to_list(passageiroViagem(ViagemId, CaronaId, Aceito, Rota, Avaliacao, PassageiroCpf),
            [ViagemId, CaronaId, Aceito, Rota, Avaliacao, PassageiroCpf]).
