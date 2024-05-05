:- module(_,[
    possui_carona_origem_destino/2,
    mostrar_caronas_origem_destino/3, 
    mostrar_caronas_passageiro_participa/2,
    adicionar_passageiro_carona/3,
    remover_passageiro_carona/3,
    criar_carona_motorista/6,
    iniciar_carona_status/1,
    finalizar_carona_status/1,
    cancelar_carona/1,
    carona_possui_origem_destino/3,
    solicitar_participar_carona/5,
    recuperar_caronas_por_motorista/2,
    mostrar_caronas_nao_iniciadas_por_motorista/2,
    get_caronas_by_passageiro/2
    ]).

:- use_module('src/Schemas/CsvModule.pl').
:- use_module('src/Model/Carona.pl').
:- use_module('src/Logic/PassageiroViagemLogic.pl').

% Définir le chemin du fichier CSV comme une variable globale
csv_file('database/caronas.csv').
carona_column(1).
hora_column(2).
data_column(3).
destinos_column(4).
motorista_column(5).
passageiros_column(6).
valor_column(7).
status_column(8).
lim_pass_column(9).
avaliacao_column(10).

viagens_csv('database/viagemPassageiros.csv').
viagem_carona_column(2).
viagem_passageiro_column(6).

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
encontrar_maior_id([row(Id, _, _, _, _, _, _, _, _, _)|Rest], MaiorId, R) :-
    MaiorId < Id,
    encontrar_maior_id(Rest, Id, R).
encontrar_maior_id([_|Rest], MaiorId, R) :-
    encontrar_maior_id(Rest, MaiorId, R).

incrementa_id :- retract(id(X)), Y is X + 1, assertz(id(Y)).

get_caronas_by_passageiro(PassageiroCpf, Caronas):- 
    csv_file(File),
    viagens_csv(ViagemFile),
    viagem_passageiro_column(VPass_Column),
    getAllRows(File, AllCaronas),
    read_csv_row(ViagemFile, VPass_Column, PassageiroCpf, ViagensPassageiro),
    findall(Carona, (member(Carona, AllCaronas), carona_in_viagens(Carona, ViagensPassageiro)), Caronas).

carona_in_viagens(Carona, Viagens) :-
    Carona = row(IdCarona,_,_,_,_,_,_,_,_,_),
    memberchk(row(_,IdCarona,'True',_,_,_), Viagens).

% Predicate to check if a route exists from Origem to Destino
possui_carona_origem_destino(Origem, Destino):-
    csv_file(File),
    destinos_column(Dest_column),
    read_csv_row_by_list_element(File, Dest_column, Origem, Rows),
    member(row(_, _, _, Trajeto, _, _, _, _, _, _), Rows),
    split_string(Trajeto, ";", "", ListaTrajeto),
    ordered_pair_in_list([Origem, Destino], ListaTrajeto).

carona_possui_origem_destino(IdCarona, Origem, Destino):-
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Rows),
    member(row(IdCarona, _, _, Trajeto, _, _, _, _, _, _), Rows),
    split_string(Trajeto, ";", "", ListaTrajeto),
    ordered_pair_in_list([Origem, Destino], ListaTrajeto).

% Helper predicate to check if two elements exist in a list in the given order
ordered_pair_in_list([X,Y], [X|T]) :-
    member(Y, T).
ordered_pair_in_list(Pair, [_|T]) :-
    ordered_pair_in_list(Pair, T).

mostrar_caronas_origem_destino(Origem, Destino, CorrespondingRowsStr):-
    csv_file(File),
    destinos_column(Dest_column),
    read_csv_row_by_list_element(File, Dest_column, Origem, Rows),
    findall(Str, (member(Row, Rows), row(_, _, _, Trajeto, _, _, _, _, _, _) = Row, split_string(Trajeto, ";", "", ListaTrajeto), ordered_pair_in_list([Origem, Destino], ListaTrajeto), caronaToStr(Row, Str)), CorrespondingRowsStr).

mostrar_caronas_passageiro_participa(PassageiroCpf, CaronasStr):-
    csv_file(File),
    passageiros_column(Pass_Column),
    atom_string(PassageiroCpf, PassStr),
    read_csv_row_by_list_element(File, Pass_Column, PassStr, Rows),
    findall(Str, (member(Row, Rows), caronaToStr(Row, Str)), CaronasStr).
% mostrar_caronas_passageiro_participa(11221122112, Str).

adicionar_passageiro_carona(IdCarona, PassageiroCpf, Resp):-
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Caronas),
    (member(row(IdCarona, Hora, Data, Destino, Motorista, Passageiros, Valor, emAndamento, Limite_Vagas, Aval), Caronas),
    passageiro_aceito_carona(IdCarona, PassageiroCpf) ->
        atom_string(Passageiros, PassageirosString),
        split_string(PassageirosString, ";", "", PassageirosList),
        length(PassageirosList, QtdPass),
        atom_string(PassageiroCpf, PassStr),
        (((QtdPass >= Limite_Vagas, \+ PassageirosList = [""]) ; member(PassStr, PassageirosList)) ->
            Resp = 'Carona com capacidade máxima de passageiros!'
        ;
            (   PassageirosString == "" -> Nova_Lista_Passageiros_Str = PassStr
                ;   atomic_list_concat([PassStr, PassageirosString], ";", Nova_Lista_Passageiros_Str)
            ),
            UpdatedRow = row(IdCarona, Hora, Data, Destino, Motorista, Nova_Lista_Passageiros_Str, Valor, emAndamento, Limite_Vagas, Aval),
            update_csv_row(File, Carona_Column, IdCarona, UpdatedRow),
            Resp = 'Passageiro adicionado com sucesso!'
        )
    ;
        Resp = 'Carona indisponível!'
    ).
% adicionar_passageiro_carona(2,121212,R).    

remover_passageiro_carona(IdCarona, PassageiroCpf, Resp):-
    csv_file(File),
    carona_column(Carona_Column),
    atom_string(PassageiroCpf, PassStr),
    read_csv_row(File, Carona_Column, IdCarona, Caronas),
    (member(row(IdCarona, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao), Caronas),
    atom_string(Passageiros, PassageirosString),
    split_string(PassageirosString, ";", "", PassageirosList),
    member(PassStr, PassageirosList) ->
        delete(PassageirosList, PassStr, UpdatedPassageirosList),
        atomics_to_string(UpdatedPassageirosList, ";", UpdatedPassageiros),
        UpdatedRow = row(IdCarona, Hora, Data, Rota, MotoristaCpf, UpdatedPassageiros, Valor, Status, Vagas, Avaliacao),
        update_csv_row(File, Carona_Column, IdCarona, UpdatedRow),
        Resp = 'Passageiro removido com sucesso!'
    ;
        Resp = 'Nenhuma carona correspondente a passageiro encontrada!'
    ).
% remover_passageiro_carona(2,11221122112, R).

solicitar_participar_carona(IdCarona, PassageiroCpf, Origem, Destino, Resp):-
    csv_file(File),
    carona_column(Carona_Column),
    (carona_possui_origem_destino(IdCarona, Origem, Destino) ->
        read_csv_row(File, Carona_Column, IdCarona, Caronas),
        (member(row(IdCarona, _, _, _, Motorista, Passageiros, _, Status, Limite_Vagas, _), Caronas),
        Status \= 'Finalizada' ->
            (   integer(Passageiros) -> number_string(Passageiros, PassageirosStr)
            ;   PassageirosStr = Passageiros
            ),
            split_string(PassageirosStr, ";", "", ListaPassageiros),
            length(ListaPassageiros, QtdPass),
            number_string(PassageiroCpf, PassageiroStr),  % Convert PassageiroCpf to a string
            (QtdPass == Limite_Vagas, \+ member(PassageiroStr, ListaPassageiros) ->
                Resp = 'Carona com capacidade máxima de passageiros!'
            ;
                format(string(Rota), "~w;~w", [Origem, Destino]),  % Corrected string formatting
                format(string(Mensagem), "O Passageiro: ~w solicitou entrar na corrida de id: ~w", [PassageiroCpf, IdCarona]),  % Corrected format/2 usage
                % insere_notificacao(Motorista, PassageiroCpf, IdCarona, Mensagem),
                criar_viagem_passageiro(IdCarona, "False", Rota, 0, PassageiroCpf),
                Resp = 'Registro de passageiro em carona criado com sucesso!'
            )
        ;
            Resp = 'Carona indisponível!'
        )
    ;
        Resp = 'Rota não encontrada!'
    ).
% solicitar_participar_carona(2,121212,"Patos","Rio",R).

criar_carona_motorista(Hora, Data, Rota, MotoristaCpf, Valor, NumPassageirosMaximos) :-
    csv_file(CsvFile),
    id(ID),
    Carona = carona(ID, Hora, Data, Rota, MotoristaCpf, [], Valor, naoIniciada, NumPassageirosMaximos, -1),
    incrementa_id,
    carona_to_list(Carona, ListaCarona),
    write_csv_row_all_steps(CsvFile, ListaCarona).
    
iniciar_carona_status(Cid) :-
    csv_file(File),
    carona_column(CaronaColumn),
    read_csv_row(File, CaronaColumn , Cid, Caronas),
    (Caronas == [] ->
        write('Nenhuma carona correspondente a esse ID foi encontrada!')
    ;
        member(row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao), Caronas),
        (Status == naoIniciada ->
            UpdatedRow = row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, emAndamento, Vagas, Avaliacao),
            update_csv_row(File, CaronaColumn, Cid, UpdatedRow)
            ;
            write('Essa carona não pode ser iniciada!')
        )
    ).
        
finalizar_carona_status(Cid) :-
    csv_file(File),
    carona_column(CaronaColumn),
    read_csv_row(File, CaronaColumn , Cid, Caronas),
    (Caronas == [] ->
        write('Nenhuma carona correspondente a esse ID foi encontrada!')
    ;
        member(row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, Status, Vagas, Avaliacao), Caronas),
        (Status == emAndamento ->
            UpdatedRow = row(Cid, Hora, Data, Rota, MotoristaCpf, Passageiros, Valor, finalizada, Vagas, Avaliacao),
            update_csv_row(File, CaronaColumn, Cid, UpdatedRow)
            ;
            write('Essa carona não pode ser finalizada!')
        )
    ).

cancelar_carona(Cid) :-
    csv_file(File),
    carona_column(CaronaColumn),
    read_csv_row(File, CaronaColumn , Cid, Caronas),
    (Caronas == [] ->
        write('Nenhuma carona correspondente a esse ID foi encontrada!')
    ;
        member(row(Cid, _, _, _, _, _, _, Status, _, _), Caronas),
        (\+ Status == naoIniciada ->
            write('Essa carona nao pode ser cancelada!')
            ;
            delete_csv_row(File,CaronaColumn, Cid),
            write('Carona deletada com sucesso!')
        )
    ).

recuperar_caronas_por_motorista(MotoristaCpf, Rows) :-
    csv_file(File),
    motorista_column(MotoristaColumn),
    read_csv_row(File, MotoristaColumn, MotoristaCpf, Rows).

mostrar_caronas_nao_iniciadas_por_motorista(MotoristaCpf, CorrespondingRowsStr) :-
    recuperar_caronas_por_motorista(MotoristaCpf, Rows),
    findall(Str, (member(Row, Rows), row(_, _, _, _, _, _, _, naoIniciada, _, _) = Row, caronaToStr(Row, Str)), CorrespondingRowsStr).