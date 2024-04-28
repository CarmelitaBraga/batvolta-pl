:- module(_,
    [possui_caronas_origem_destino_controller/2,
    mostrar_caronas_disponiveis_origem_destino/3
    % solicitar_carona_passageiro/5,
    % mostrar_viagem_passageiro/2,
    % cancelar_carona_passageiro/2,
    % mostrar_viagem_passageiro/2,
    % mostrar_caronas_passageiro/2,
    % desembarcar_passageiro/2,
    % embarcar_passageiro/2,
    % get_viagem_sem_avaliacao/2,
    % avaliar_motorista/4
    ]).

:- use_module('src/Logic/CaronaLogic.pl').


% Carona & passageiro

possui_caronas_origem_destino_controller(Origem, Destino):-
    call(possui_carona_origem_destino(Origem, Destino)).

mostrar_caronas_disponiveis_origem_destino(Origem, Destino, Caronas):-
    mostra_caronas_origem_destino(Origem, Destino, Caronas).

% solicitar_carona_passageiro(CId, PassageiroRef, Origem, Destino, MaybeCaronaEscolhida).

% mostrar_viagem_passageiro(PassageiroCpf, Viagens).

% cancelar_carona_passageiro(CId, PassageiroCpf).

% mostrar_viagem_passageiro(PassageiroCpf, Resultado).

% mostrar_caronas_passageiro(PassageiroCpf, Resultado).

% desembarcar_passageiro(IdCarona, PassageiroCpf).

% embarcar_passageiro(IdCarona, PassageiroCpf).

% get_viagem_sem_avaliacao(PassageiroCpf, Caronas).

% avaliar_motorista(IdCarona, PassageiroCpf, Avaliacao, Resultado).

% Carona & motorista