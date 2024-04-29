:- module(_, 
    [info_trecho_by_carona_passageiro/3,
    cancelar_viagem_passageiro/3,
    get_viagens_passageiro_sem_avaliacao/2
    ]).

:- use_module('src/Schemas/CsvModule.pl').

csv_file('database/viagemPassageiros.csv').
viagem_pass_column(1).
carona_column(2).
aceito_column(3).
rota_column(4).
avaliacao_column(5).
passageiro_column(6).
nota_sem_avaliacao(0).

get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Resp):- 
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Viagens),
    (member(row(_, IdCarona, _, _, _, PassageiroCpf), Viagens) ->
        Resp = Viagens
    ;
        Resp = []
    ).

get_viagens_passageiro_sem_avaliacao(PassageiroCpf, Resp):-
    csv_file(File),
    number_string(PassageiroCpf, PassageiroStr),
    nota_sem_avaliacao(Sem_Nota),
    avaliacao_column(Aval_Column),
    read_csv_row(File, Aval_Column, Sem_Nota, Viagens),
    findall(Viagem, (member(Viagem, Viagens), Viagem = row(_, _, _, _, Sem_Nota, Passageiro), atom_string(Passageiro, PassageiroStr)), Resp).
% get_viagens_passageiro_sem_avaliacao(09876543210,R).
% get_viagens_passageiro_sem_avaliacao(121212,R).
% get_viagens_passageiro_sem_avaliacao(000000,R).

remover_viagem(IdViagem):- 
    csv_file(File),
    viagem_pass_column(Viagem_Column),
    delete_csv_row(File, Viagem_Column, IdViagem).

viagem_aceita(IdViagem):- 
    csv_file(File),
    viagem_pass_column(Viagem_Column),
    read_csv_row(File, Viagem_Column, IdViagem, Viagens),
    (member(row(IdViagem, _, Aceito, _, _, _), Viagens) ->
        (Aceito = 'True' ->
            true
        ;
            false)
    ;
        false
    ).

% Recebe um átomo
info_trecho_by_carona_passageiro(IdCarona, PassageiroCpf, Resp):- 
    get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Viagem),
    (Viagem = [] ->
        Resp = 'Nenhum trecho correspondente a passageiro encontrado!'
    ;
        Resp = Viagem
    ).
% info_trecho_by_carona_passageiro(7,09876543210, T).
% info_trecho_by_carona_passageiro(8,09876543210, T).

% cancelar_carona_passageiro/2,
cancelar_viagem_passageiro(IdCarona, PassageiroCpf, Resp):-
    get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Viagem),
    (Viagem = [] ->
        Resp = 'Trecho de carona inexistente para o passageiro informado!'
    ;
        Viagem = [row(IdViagem, IdCarona, _, _, _, PassageiroCpf)|_],
        (viagem_aceita(IdViagem) ->
            Resp = 'O passageiro ja foi aceito, não podera mais cancelar.'
        ;
            remover_viagem(IdViagem),
            Resp = 'Carona cancelada com sucesso!'
        )
    ).
% cancelar_viagem_passageiro(7,000000, R).
% cancelar_viagem_passageiro(7,09876543210, R).
% cancelar_viagem_passageiro(2,000000, R).

% mostrar_viagem_passageiro/2,
% get_viagem_sem_avaliacao/2,
% avaliar_motorista/4
% criarViagemPassageiro