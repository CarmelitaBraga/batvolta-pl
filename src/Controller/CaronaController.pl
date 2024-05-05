:- module(_,
    [possui_caronas_origem_destino_controller/2,
    mostrar_caronas_disponiveis_origem_destino/3,
    mostrar_caronas_passageiro/2,
    cancelar_carona_passageiro/3,
    mostrar_viagem_passageiro/2,
    get_viagem_sem_avaliacao/2,
    avaliar_motorista/4,
    embarcar_passageiro/3,
    desembarcar_passageiro/3,
    solicitar_carona_passageiro/5,
    criar_carona/6,
    inicializar_carona_status/1,
    possui_carona_nao_iniciada_controller/1,
    mostrar_viagens_por_motorista/2,
    mostrar_viagens_carona/2,
    mostrar_todas_as_viagens/1,
    mostrar_caronas_por_passageiro/2
    ]).

:- use_module('src/Logic/CaronaLogic.pl').
:- use_module('src/Logic/PassageiroViagemLogic.pl').

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
desembarcar_passageiro(IdCarona, PassageiroCpf, Result):- 
    remover_passageiro_carona(IdCarona, PassageiroCpf, Result).
% desembarcar_passageiro(0,486464646410,R).

mostrar_viagem_passageiro(PassageiroCpf, Viagens):-
    mostrar_viagens_passageiro_str(PassageiroCpf, Viagens).
% mostrar_viagem_passageiro(121212, R).

cancelar_carona_passageiro(CId, PassageiroCpf, Resp):-
    cancelar_viagem_passageiro(CId, PassageiroCpf, Resp).
% cancelar_carona_passageiro(1, 000000, R).
% cancelar_carona_passageiro(2, 000000, R).
% cancelar_carona_passageiro(3, 000000, R).

get_viagem_sem_avaliacao(PassageiroCpf, Caronas):-
    get_viagens_passageiro_sem_avaliacao(PassageiroCpf, Caronas).
% get_viagem_sem_avaliacao(000000, R).
% get_viagem_sem_avaliacao(479798, R).

solicitar_carona_passageiro(IdCarona, PassageiroCpf, Origem, Destino, Result):-
    solicitar_participar_carona(IdCarona, PassageiroCpf, Origem, Destino, Result).
% solicitar_carona_passageiro(0, 951159, "Sao Paulo", "Rio", R).

embarcar_passageiro(IdCarona, PassageiroCpf, Result):-
    adicionar_passageiro_carona(IdCarona, PassageiroCpf, Result).
% embarcar_passageiro(0, 951159,R).

avaliar_motorista(IdCarona, PassageiroCpf, Avaliacao, Resultado):-
    carona_avalia_motorista(IdCarona, PassageiroCpf, Avaliacao, Resultado).
% avaliar_motorista(7,09876543210,5,R).

% Carona & motorista
criar_carona(Hora, Data, Rota, MotoristaCpf, Valor, NumPassageirosMaximos) :-
    criar_carona_motorista(Hora, Data, Rota, MotoristaCpf, Valor, NumPassageirosMaximos).

inicializar_carona_status(Cid) :-
    iniciar_carona_status(Cid).

possui_carona_nao_iniciada_controller(MotoristaCpf) :- 
    mostrar_caronas_nao_iniciadas_por_motorista(MotoristaCpf, Caronas),
    list_to_string(Caronas, '', CaronasStr),
    CaronasStr = "".

mostrar_viagens_por_motorista(MotoristaCpf, Rows):-
    recuperar_caronas_por_motorista(MotoristaCpf, Rows).

mostrar_viagens_carona(IdCarona, Viagens):-
    get_viagens_by_carona(IdCarona, Viagens).

mostrar_todas_as_viagens(Viagens):-
    get_all_viagens(Viagens).

mostrar_caronas_por_passageiro(PassageiroCpf, Rows):-
    mostrar_caronas_por_passageiro(PassageiroCpf, Rows).