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
    mostrar_caronas_nao_iniciadas_controller/2,
    checar_carona_nao_iniciada_de_motorista/2,
    inicializar_carona_status/1,
    finaliza_carona_status/1,
    possui_carona_em_andamento_controller/1,
    mostrar_caronas_em_andamento_controller/2,
    checar_carona_em_andamento_de_motorista/2,
    possui_passageiros_viagem_false_controller/1,
    possui_carona_motorista_controller/1,
    mostrar_caronas_motorista/2,
    cancelar_carona_controller/2,
    checar_carona_de_motorista/2,
    mostrar_carona_passageiros_viagem_false_controller/2,
    mostrar_caronas_sem_avaliacao_controller/2,
    checar_carona_de_motorista_avaliar/2,
    avaliar_carona_controller/2,
    checar_carona_passageiro_viagem_false/2,
    mostrar_passageiros_viagem_false_controller/2,
    possui_passageiro_viagem_false_controller/2,
    aceitar_ou_recusar_passageiro_controller/2,
    possui_carona_sem_avaliacao_controller/1,
    mostrar_caronas_sem_avaliacao_controller/2
    ]).

:- use_module('../Logic/CaronaLogic.pl').
:- use_module('../Logic/PassageiroViagemLogic.pl').
:- use_module('../Util/Utils.pl').


% Carona & passageiro

possui_caronas_origem_destino_controller(Origem, Destino):-
    call(possui_carona_com_vagas_origem_destino(Origem, Destino)).
% mostrar_caronas_disponiveis_origem_destino("Patos", "Ottawa", Str).

mostrar_caronas_disponiveis_origem_destino(Origem, Destino, Caronas):-
    mostrar_caronas_com_vagas_origem_destino(Origem, Destino, Caronas).
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
    mostrar_all_viagens_passageiro(PassageiroCpf, Viagens).
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
    \+ CaronasStr = ''.

mostrar_caronas_nao_iniciadas_controller(MotoristaCpf, CaronasStr) :-
    mostrar_caronas_nao_iniciadas_por_motorista(MotoristaCpf, Caronas),
    list_to_string(Caronas, '', CaronasStr).

checar_carona_nao_iniciada_de_motorista(MotoristaCpf, Cid) :-
    checar_carona_nao_iniciada_e_motorista(MotoristaCpf, Cid).

finaliza_carona_status(Cid) :-
    finalizar_carona_status(Cid).

possui_carona_em_andamento_controller(MotoristaCpf) :- 
    mostrar_caronas_em_andamento_por_motorista(MotoristaCpf, Caronas),
    list_to_string(Caronas, '', CaronasStr),
    \+ CaronasStr = ''.

mostrar_caronas_em_andamento_controller(MotoristaCpf, CaronasStr) :-
    mostrar_caronas_em_andamento_por_motorista(MotoristaCpf, Caronas),
    list_to_string(Caronas, '', CaronasStr).

checar_carona_em_andamento_de_motorista(MotoristaCpf, Cid) :-
    checar_carona_em_andamento_e_motorista(MotoristaCpf, Cid).

possui_passageiros_viagem_false_controller(MotoristaCpf) :-
    recuperar_caronas_por_motorista(MotoristaCpf, Rows),
    Rows \= [],
    possui_passageiros_viagem_false(Rows).

possui_carona_motorista_controller(MotoristaCpf):-
    possui_carona_motorista(MotoristaCpf).

mostrar_caronas_motorista(MotoristaCpf, CaronasStr):-
    mostrar_caronas_do_motorista(MotoristaCpf, Caronas),
    list_to_string(Caronas, '', CaronasStr).

cancelar_carona_controller(Cid,Resposta):-
    cancelar_carona(Cid,Resposta).

checar_carona_de_motorista(Motorista,Cid):-
    carona_de_motorista(Motorista,Cid).

possui_carona_sem_avaliacao_controller(Motorista):-
    possui_carona_sem_avaliacao(Motorista).

mostrar_caronas_sem_avaliacao_controller(MotoristaCpf, Caronas):-
    mostrar_caronas_sem_avaliacao(MotoristaCpf,Caronas).

mostrar_carona_passageiros_viagem_false_controller(MotoristaCpf, CaronasStr):-
    mostrar_carona_passageiros_viagem_false(MotoristaCpf, CaronasStrLista),
    list_to_string(CaronasStrLista, '', CaronasStr).

checar_carona_de_motorista_avaliar(Cid, MotoristaCpf):-
    carona_de_motorista_avaliar(Cid,MotoristaCpf).

avaliar_carona_controller(Cid, Avaliacao):-
    avaliar_carona(Cid, Avaliacao).

checar_carona_passageiro_viagem_false(MotoristaCpf, Cid) :- 
    carona_de_motorista(MotoristaCpf,Cid),
    retornar_carona(Cid, Row),
    possui_passageiros_false(Row).

mostrar_passageiros_viagem_false_controller(Cid, Passageiros) :-
    retorna_passageiros_false_da_carona(Cid, Passageiros).

possui_passageiro_viagem_false_controller(Cid, PVid) :-
    possui_passageiro_viagem_false(Cid, PVid).

aceitar_ou_recusar_passageiro_controller(PVid, AceitarOuRecusar) :-
    (AceitarOuRecusar = 'aceito' ->
        aceitar_passageiro(PVid)
    ;
        remover_viagem(PVid)
    ).