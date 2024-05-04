:- module(_, 
    [info_trecho_by_carona_passageiro/3,
    cancelar_viagem_passageiro/3,
    get_viagens_passageiro_sem_avaliacao/2,
    mostrar_all_viagens_passageiro/2,
    cancelar_viagem_passageiro/3,
    carona_avalia_motorista/4,
    criar_viagem_passageiro/5,
    passageiro_tem_registro_carona/2,
    passageiro_aceito_carona/2,
    get_viagens_by_carona/2,
    get_all_viagens/1
    ]).

:- use_module('src/Schemas/CsvModule.pl').
:- use_module('src/Model/PassageiroViagem.pl').

% Fato dinâmico para gerar o id das caronas
:- dynamic id/1.
% Fato estático para inicializar o ID ao carregar o módulo
:- initialization(loadId).
loadId :-
    csv_file(File),
    getAllRows(File, Rows),
    
    (Rows = [] ->
    assertz(id(0))
    ;
    encontrar_maior_id(Rows, 0, Id),
    NovoId is Id + 1,
assertz(id(NovoId))
).

encontrar_maior_id([], MaiorId, MaiorId).
encontrar_maior_id([row(Id, _, _, _, _, _)|Rest], MaiorId, R) :-
    MaiorId < Id,
    encontrar_maior_id(Rest, Id, R).
encontrar_maior_id([_|Rest], MaiorId, R) :-
    encontrar_maior_id(Rest, MaiorId, R).

incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).


csv_file('database/viagemPassageiros.csv').
viagem_pass_column(1).
carona_column(2).
aceito_column(3).
rota_column(4).
avaliacao_column(5).
passageiro_column(6).
nota_sem_avaliacao(0).

get_all_viagens(Viagens):-
    csv_file(File),
    getAllRows(File, Viagens).

passageiro_tem_registro_carona(IdCarona, PassageiroCpf):-
    get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Viagem),
    (Viagem == []-> 
        false
    ;
        true
    ).

passageiro_aceito_carona(IdCarona, PassageiroCpf):- 
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Viagens),
    member(row(_, IdCarona, 'True', _, _, PassageiroCpf), Viagens).


get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Resp):- 
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Viagens),
    (member(row(_, IdCarona, _, _, _, PassageiroCpf), Viagens) ->
        Resp = Viagens
    ;
        Resp = []
    ).

get_viagens_passageiro_sem_avaliacao(PassageiroCpf, ViagensStr):-
    csv_file(File),
    number_string(PassageiroCpf, PassageiroStr),
    nota_sem_avaliacao(Sem_Nota),
    avaliacao_column(Aval_Column),
    read_csv_row(File, Aval_Column, Sem_Nota, Viagens),
    findall(ViagemStr, (member(Viagem, Viagens), Viagem = row(_, _, 'True', _, Sem_Nota, Passageiro), atom_string(Passageiro, PassageiroStr), viagemToStr(Viagem, ViagemStr)), ViagensStr).
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

info_trecho_by_carona_passageiro(IdCarona, PassageiroCpf, Resp):- 
    get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Viagem),
    (Viagem = [] ->
        Resp = 'Nenhum trecho correspondente a passageiro encontrado!'
    ;
        Resp = Viagem
        % Viagem = [V|_],
        % viagemToStr(V, Resp)
    ).
% info_trecho_by_carona_passageiro(7,09876543210, T).
% info_trecho_by_carona_passageiro(8,09876543210, T).

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

mostrar_all_viagens_passageiro(PassageiroCpf, ViagensStr):- 
    csv_file(File),
    number_string(PassageiroCpf, PassageiroStr),
    passageiro_column(Pass_Column),
    read_csv_row(File, Pass_Column, PassageiroCpf, Viagens),
    findall(ViagemStr, (member(Viagem, Viagens), Viagem = row(_, _, _, _, _, Passageiro), atom_string(Passageiro, PassageiroStr), viagemToStr(Viagem, ViagemStr)), ViagensStr).

carona_avalia_motorista(IdCarona, PassageiroCpf, Avaliacao, Resp):- 
    csv_file(File),
    nota_sem_avaliacao(Sem_Nota),
    viagem_pass_column(Viagem_Column),
    (Avaliacao =< 0 ; Avaliacao > 5 ->
        Resp = 'Valor inválido!'
    ;
        get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Viagem),
        (member(row(IdViagem,IdCarona,Aceito,Rota,Sem_Nota,PassageiroCpf), Viagem) ->
            Updated_Row = row(IdViagem,IdCarona,Aceito,Rota,Avaliacao,PassageiroCpf),
            update_csv_row(File, Viagem_Column, IdViagem, Updated_Row),
            Resp = 'Carona avaliada com sucesso!'
        ;
            Resp = 'Nenhuma carona não avaliada encontrada com este id.'
    )).

criar_viagem_passageiro(IdCarona, Aceito, Rota, Avaliacao, PassageiroCpf):-
    id(ID),
    csv_file(File),
    (Aceito == "False" ; Aceito == "True"),
    Viagem = passageiroViagem(ID, IdCarona, Aceito, Rota, Avaliacao, PassageiroCpf),
    incrementa_id,
    viagem_to_list(Viagem, ListaViagem),
    write_csv_row_all_steps(File, ListaViagem).
% criar_viagem_passageiro(7,"True","Osasco;Disney", 0, 111555888).

get_viagens_by_carona(IdCarona, Viagens):-
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, ViagensRows),
    (member(row(_, IdCarona, _, _, _, _), ViagensRows) ->
        Viagens = ViagensRows
    ;
        Viagens = []
    ).
