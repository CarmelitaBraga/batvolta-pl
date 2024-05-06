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
    possui_passageiros_viagem_false/1,
    retornar_caronas_passageiro_false/2,
    possui_passageiros_false/1,
    retorna_passageiros_false_da_carona/2,
    possui_passageiro_viagem_false/2,
    aceitar_passageiro/1,
    get_viagens_by_carona/2,
    get_all_viagens/1,
    possui_espaco_disponivel/4,
    remover_viagem/1
    ]).

:- use_module('../Schemas/CsvModule.pl').
:- use_module('../Model/PassageiroViagem.pl').
:- use_module('../Util/Utils.pl').

csv_file('../../database/viagemPassageiros.csv').

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

get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Resp):- 
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Viagens),
    (member(row(_, IdCarona, _, _, _, PassageiroCpf), Viagens) ->
        Resp = Viagens
    ;
        Resp = []
    ).

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
    % number_string(PassageiroCpf, PassageiroStr),
    nota_sem_avaliacao(Sem_Nota),
    avaliacao_column(Aval_Column),
    read_csv_row(File, Aval_Column, Sem_Nota, Viagens),
    findall(ViagemStr, (member(Viagem, Viagens), Viagem = row(_, _, 'True', _, Sem_Nota, PassageiroCpf), viagemToStr(Viagem, ViagemStr)), ViagensStr).
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
        member(row(IdViagem, IdCarona, Aceito, _, _, PassageiroCpf), Viagem),
        (Aceito = 'True' ->
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
    % number_string(PassageiroCpf, PassageiroStr),
    passageiro_column(Pass_Column),
    read_csv_row(File, Pass_Column, PassageiroCpf, Viagens),
    findall(ViagemStr, (member(Viagem, Viagens), Viagem = row(_, _, _, _, _, PassageiroCpf), viagemToStr(Viagem, ViagemStr)), ViagensStr).

carona_avalia_motorista(IdCarona, PassageiroCpf, Avaliacao, Resp):- 
    csv_file(File),
    nota_sem_avaliacao(Sem_Nota),
    viagem_pass_column(Viagem_Column),
    (Avaliacao =< 0 ; Avaliacao > 5 ->
        Resp = 'Valor invalido!'
    ;
        get_viagem_by_carona_passageiro(IdCarona, PassageiroCpf, Viagem),
        (member(row(IdViagem,IdCarona,Aceito,Rota,Sem_Nota,PassageiroCpf), Viagem) ->
            Updated_Row = row(IdViagem,IdCarona,Aceito,Rota,Avaliacao,PassageiroCpf),
            update_csv_row(File, Viagem_Column, IdViagem, Updated_Row),
            Resp = 'Carona avaliada com sucesso!'
        ;
            Resp = 'Nenhuma carona nao avaliada encontrada com este id.'
    )).

criar_viagem_passageiro(IdCarona, Aceito, Rota, Avaliacao, PassageiroCpf):-
    id(ID),
    csv_file(File),
    (Aceito == 'False' ; Aceito == 'True'),
    Viagem = passageiroViagem(ID, IdCarona, Aceito, Rota, Avaliacao, PassageiroCpf),
    incrementa_id,
    viagem_to_list(Viagem, ListaViagem),
    write_csv_row_all_steps(File, ListaViagem).
% criar_viagem_passageiro(7,"True","Osasco;Disney", 0, 111555888).

possui_passageiros_false(row(IdCarona, _, _, _, _, _, _, _, _, _)) :-
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Viagens),
    findall(_, (
        member(Viagem, Viagens),
        Viagem = row(_, _, 'False', _, _, _),
    viagemToStr(Viagem, _)
    ), ViagensStr),
    ViagensStr \= [].

possui_passageiros_viagem_false([Row|_]) :-
    possui_passageiros_false(Row), !.
possui_passageiros_viagem_false([_|Rest]) :- possui_passageiros_viagem_false(Rest).

retornar_caronas_passageiro_false(Caronas, CaronasPassageiroFalse) :-
    include(possui_passageiros_false, Caronas, CaronasPassageiroFalse).

retorna_passageiros_false_da_carona(Cid, Retorno) :-
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, Cid, Viagens),
    findall(ViagemStr, (
        member(Viagem, Viagens),
        Viagem = row(_, _, 'False', _, _, _),
        viagemToStr(Viagem, ViagemStr)
    ), ViagensStr),
    atomic_list_concat(ViagensStr, '\n', Retorno).

possui_passageiro_viagem_false(Cid, PVid) :-
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, Cid, Viagens),
    member(row(PVid, Cid, 'False', _, _, _), Viagens),!.

aceitar_passageiro(PVid) :-
    csv_file(File),
    viagem_pass_column(ViagemIdColumn),
    read_csv_row(File, ViagemIdColumn, PVid, Viagens),
    member(row(PVid,IdCarona,_,Rota,Avaliacao,PassageiroCpf), Viagens),
    Updated_Row = row(PVid,IdCarona,'True',Rota,Avaliacao,PassageiroCpf),
    update_csv_row(File, ViagemIdColumn, PVid, Updated_Row).

get_viagens_by_carona(IdCarona, Viagens):-
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, ViagensRows),
    (member(row(_, IdCarona, _, _, _, _), ViagensRows) ->
        Viagens = ViagensRows
    ;
        Viagens = []
    ).

% Helper predicate to check if any element of the first list is in the second list
esta_em([], _) :- fail.
esta_em([X|Resto], Lista) :-
    member(X, Lista);
    esta_em(Resto, Lista), !.

% Helper predicate to remove the last element from a list
sem_ultimo([], []).
sem_ultimo([_], []).
sem_ultimo([X|Resto], [X|SemUltimo]) :-
    sem_ultimo(Resto, SemUltimo), !.

% Predicate to check if a row has a route
possui_rota(row(_, CaronaId, _, Trajeto, _, _), CaronaId, Rota) :-
    split_string(Trajeto, ";", "", ListaTrajeto),
    list_to_atom_list(ListaTrajeto, AtomList),
    sem_ultimo(AtomList, Destinos),
    esta_em(Destinos, Rota).

% Predicate to filter rows that belong to a route and have the same carona id
filter_pertence_a_rota([], _, _, []).
filter_pertence_a_rota([Row|Rows], CaronaId, Rota, FilteredRows) :-
    (possui_rota(Row, CaronaId, Rota) -> 
        filter_pertence_a_rota(Rows, CaronaId, Rota, Rest), 
        FilteredRows = [Row|Rest]
    ;
        filter_pertence_a_rota(Rows, CaronaId, Rota, FilteredRows)
    ).

% Predicate to check if a given trip has available space
possui_espaco_disponivel(CaronaId, Trajeto, NumPassageirosMaximos, [R|Rota]) :-
    csv_file(File),
    getAllRows(File, ViagensRows),
    last(Rota, Last),
    ordered_pair_in_list([R|[Last]], Trajeto),
    filter_pertence_a_rota(ViagensRows, CaronaId, [R|Rota], ViagensStr),
    length(ViagensStr, Length),
    NumPassageirosMaximos > Length.
