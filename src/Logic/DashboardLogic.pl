:- module(_, [
        get_top_motoristas/1,
        get_top_motoristas_by_regiao/2
    ]).

:- use_module('src/Controller/ControllerMotorista.pl').
:- use_module('src/Controller/CaronaController.pl').
:- use_module('src/Util/Utils.pl').

motoristas_csv('database/motoristas.csv').
caronas_csv('database/caronas.csv').
viagens_csv('database/viagemPassageiros.csv').

cpf_motorista(row(Cpf, _, _, _, _, _, _, _, _), Cpf).
avaliacao_motorista(row(_, _, _, _, _, _, _, _, _, Avaliacao), Avaliacao).

join_carona_viagem_by_motorista(MotoristaCpf, Viagens):-
    mostrar_viagens_por_motorista(MotoristaCpf, CaronasMotorista),
    findall(Viagem, 
            (member(row(IdCarona, _, _, _, _, _, _, _, _, _), CaronasMotorista), 
            mostrar_viagens_carona(IdCarona, Viagem)), 
        ViagensNested),
    flatten(ViagensNested, Viagens).

map_avaliacoes_motoristas(Motoristas, Result):-
    findall((MotoristaCpf, MediaAvaliacao), 
            (member(Motorista, Motoristas), 
             cpf_motorista(Motorista, MotoristaCpf), 
            %  mostrar_viagens_por_motorista(MotoristaCpf, Caronas),
             media_avaliacao_motorista(MotoristaCpf, MediaAvaliacao)), 
            Result).

media_avaliacao_motorista(MotoristaCpf, MediaAvaliacao):-
    join_carona_viagem_by_motorista(MotoristaCpf, Viagens),
    findall(Avaliacao, (member(row(_, _, _, _, Avaliacao, _), Viagens), \+ Avaliacao is 0), Avaliacoes),
    length(Avaliacoes, NumAvaliacoes),
    sum_list(Avaliacoes, TotalAvaliacoes),
    (NumAvaliacoes = 0 ->
        MediaAvaliacao = 0
    ;
        MediaAvaliacao is (TotalAvaliacoes / NumAvaliacoes)
    ).
    
% Predicate to extract the first element of a tuple
extract_first((X, _), X).

% Predicate to get the name of a driver by their CPF
get_motorista_name(MotoristaCpf, Nome):-
    mostrar_motorista_por_cpf(MotoristaCpf, row(_, Nome, _, _, _, _, _, _, _)).

% Predicate to convert a tuple of CPF and score to a string
tuple_to_string((Cpf, Score), String):-
    get_motorista_name(Cpf, Nome),
    atom_number(ScoreAtom, Score),
    atom_concat(Nome, ": ", TempString),
    atom_concat(TempString, ScoreAtom, String).

% Predicate to get the top drivers
get_top_motoristas(MelhoresMotoristas):-
    mostrar_todos_motoristas(ListaMotoristas),
    map_avaliacoes_motoristas(ListaMotoristas, TuplasMotoristasAval),
    take_evaluations_decrescent(5, TuplasMotoristasAval, TopTuples),
    maplist(tuple_to_string, TopTuples, MelhoresMotoristas).

get_top_motoristas_by_regiao(Regiao, MelhoresMotoristas):-
    recuperarMotoristasPorRegiao(Regiao, Motoristas),
    map_avaliacoes_motoristas(Motoristas, TuplasMotoristasAval),
    take_evaluations_decrescent(3, TuplasMotoristasAval, TopTuples),
    maplist(tuple_to_string, TopTuples, MelhoresMotoristas).
