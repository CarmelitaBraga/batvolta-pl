:- module(_,
    [possui_caronas_origem_destino_controller/2,
    mostrar_caronas_disponiveis_origem_destino/3,
    mostrar_caronas_passageiro/2
    % solicitar_carona_passageiro/5,
    % mostrar_viagem_passageiro/2,
    % cancelar_carona_passageiro/2,
    % desembarcar_passageiro/2,
    % embarcar_passageiro/2,
    % get_viagem_sem_avaliacao/2,
    % avaliar_motorista/4
    ]).

:- use_module('src/Logic/CaronaLogic.pl').

% Carona & passageiro

possui_caronas_origem_destino_controller(Origem, Destino):-
    call(possui_carona_origem_destino(Origem, Destino)).
% mostrar_caronas_disponiveis_origem_destino("Patos", "Ottawa", Str).

mostrar_caronas_disponiveis_origem_destino(Origem, Destino, Caronas):-
    mostrar_caronas_origem_destino(Origem, Destino, Caronas).
% mostrar_caronas_disponiveis_origem_destino("Rio","Sao Paulo", Str).

mostrar_caronas_passageiro(PassageiroCpf, Resultado):-
    mostrar_caronas_passageiro_participa(PassageiroCpf, Resultado).
% mostrar_caronas_passageiro("111",R).
% mostrar_caronas_passageiro_participa("11221122112", Str).

% Recebe PassageiroCpf como String.
desembarcar_passageiro(IdCarona, PassageiroCpf):- 
    remover_passageiro(IdCarona, PassageiroCpf).
% desembarcar_passageiro(0,"11221122112").
% desembarcar_passageiro(1,"11221122112").

% solicitar_carona_passageiro(CId, PassageiroRef, Origem, Destino, MaybeCaronaEscolhida).

% mostrar_viagem_passageiro(PassageiroCpf, Viagens).

% cancelar_carona_passageiro(CId, PassageiroCpf).

% embarcar_passageiro(IdCarona, PassageiroCpf).

% get_viagem_sem_avaliacao(PassageiroCpf, Caronas).

% avaliar_motorista(IdCarona, PassageiroCpf, Avaliacao, Resultado).

% Carona & motorista