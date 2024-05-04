
:- module(_,
        [menu_principal_passageiro_carona/1, 
        menu_procurar_carona/1, 
        menu_cancelar_carona/1, 
        menu_mostrar_caronas/1, 
        menu_desembarcar_caronas/1, 
        menu_embarcar_caronas/1, 
        menu_avaliar_motorista/1,
        
        menu_principal_motorista_carona/1,
        menu_criar_carona/1,
        menu_iniciar_carona/1,
        menu_finalizar_carona/1,
        menu_aceitar_recusar_passageiro/1,
        menu_cancelar_carona_motorista/1,
        menu_visualizar_carona/1,
        menu_avaliar_carona/1
        ]).

% get_cli_cpf(PassageiroRef, PassageiroCpf).
get_cli_cpf(PassageiroRef, 11122233344).

:- use_module('../Controller/CaronaController.pl').
:- use_module('../Util/Utils.pl').
:- use_module('../Controller/PassageiroController.pl').

menu_principal_passageiro_carona(PassageiroRef) :-
    write('\nSelecione uma opção:\n'),
    write('1 - Procurar Carona\n'),
    write('2 - Cancelar Carona\n'),
    write('3 - Ver minhas viagens\n'),
    write('4 - Embarcar na Carona\n'),
    write('5 - Desembarcar da Carona\n'),
    write('6 - Avaliar Motorista\n'),
    write('0 - Voltar\n'),
    read(Opcao),
    handle_option(Opcao, PassageiroRef).

handle_option(1, PassageiroRef) :- menu_procurar_carona(PassageiroRef), menu_principal_passageiro_carona(PassageiroRef).
handle_option(2, PassageiroRef) :- menu_cancelar_carona(PassageiroRef), menu_principal_passageiro_carona(PassageiroRef).
handle_option(3, PassageiroRef) :- menu_mostrar_caronas(PassageiroRef), menu_principal_passageiro_carona(PassageiroRef).
handle_option(4, PassageiroRef) :- menu_embarcar_caronas(PassageiroRef), menu_principal_passageiro_carona(PassageiroRef).
handle_option(5, PassageiroRef) :- menu_desembarcar_caronas(PassageiroRef), menu_principal_passageiro_carona(PassageiroRef).
handle_option(6, PassageiroRef) :- menu_avaliar_motorista(PassageiroRef), menu_principal_passageiro_carona(PassageiroRef).
handle_option(0, PassageiroRef) :- menu_opcoes_passageiro(PassageiroRef).
handle_option(_, PassageiroRef) :- write('Opção inválida!\n'), menu_principal_passageiro_carona(PassageiroRef).

% Os valores de origem e destino devem ser passados com aspas duplas :(
menu_procurar_carona(PassageiroRef):-
    write('\nDe onde a carona deve partir?(Digite sem caracteres especiais, exemplo: ´,~,...) '),
    read(Origem),
    atom_string(Origem, OrigemStr),
    write('\nOnde a carona deve chegar?(Digite sem caracteres especiais, exemplo: ´,~,...) '),
    read(DestinoStr),
    (possui_caronas_origem_destino_controller(OrigemStr, DestinoStr) ->
        mostrar_caronas_disponiveis_origem_destino(OrigemStr, DestinoStr, Caronas),
        write('Caronas disponíveis: '), nl, printList(Caronas), nl,
        write('Qual carona deseja solicitar? (Digite o Id da carona ou -1 para dispensar): '),
        read(CId),
        (CId == -1 -> menu_principal_passageiro_carona(PassageiroRef)
        ;
        solicitar_carona_passageiro(CId, PassageiroRef, OrigemStr, DestinoStr, MaybeCaronaEscolhida),
        write(MaybeCaronaEscolhida), nl,
        menu_principal_passageiro_carona(PassageiroRef))
    ;
        write('Não existem caronas para essa origem e destino!\n'),
        menu_principal_passageiro_carona(PassageiroRef)
    ).

menu_cancelar_carona(PassageiroRef):-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    mostrar_viagem_passageiro(PassageiroCpf, Caronas),
    write('Caronas: \n'), nl, printList(Caronas), nl,
    write('Digite o Id da carona que deseja cancelar (-1 para nenhuma): '),
    read(CId),
    (CId = -1 -> 
        menu_principal_passageiro_carona(PassageiroRef)
    ;
        cancelar_carona_passageiro(CId, PassageiroCpf, Resp),
        write(Resp),
        menu_principal_passageiro_carona(PassageiroRef)
    ).

menu_mostrar_caronas(PassageiroRef):-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    mostrar_viagem_passageiro(PassageiroCpf, Viagens),
    printList(Viagens),
    menu_principal_passageiro_carona(PassageiroRef).

menu_desembarcar_caronas(PassageiroRef):- 
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    mostrar_caronas_passageiro(PassageiroCpf, Caronas),
    (Caronas \= [] ->
        printList(Caronas), nl,
        write('Digite o ID da carona: '),
        read(IdCarona),
        desembarcar_passageiro(IdCarona, PassageiroCpf, Resp),
        write(Resp)
    ;
        write('Nenhuma carona disponível para desembarcar!\n'),
        menu_principal_passageiro_carona(PassageiroRef)
    ).

menu_embarcar_caronas(PassageiroRef):-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    write('Escolha a carona para embarcar: \n'),
    mostrar_viagem_passageiro(PassageiroCpf, Viagens),
    printList(Viagens), nl,
    write('Digite o ID da carona: '),
    read(IdCarona),
    embarcar_passageiro(IdCarona, PassageiroCpf, Resp),
    write(Resp), nl,
    menu_principal_passageiro_carona(PassageiroRef).

menu_avaliar_motorista(PassageiroRef) :-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    get_viagem_sem_avaliacao(PassageiroCpf, Caronas),
    (Caronas \= "" ->
        printList(Caronas), nl,
        write('Digite o ID da carona que deseja avaliar: '),
        read(IdCarona),
        write('Digite a avaliação do motorista: '),
        read(Avaliacao),
        avaliar_motorista(IdCarona, PassageiroCpf, Avaliacao, Result),
        write(Result), nl
    ;
        write('Nenhuma carona encontrada para avaliação!\n')
    ),
    menu_principal_passageiro_carona(PassageiroRef).

menu_principal_motorista_carona(MotoristaRef) :-
    writeln('\nSelecione uma opcao:'),
    writeln('1 - Criar Carona'),
    writeln('2 - Iniciar Carona'),
    writeln('3 - Finalizar Carona'),
    writeln('4 - Aceitar/Recusar passageiro'),
    writeln('5 - Cancelar Carona'),
    writeln('6 - Visualizar Caronas'),
    writeln('7 - Avaliar Carona Finalizada'),
    writeln('0 - Voltar'),
    read_line_to_string(user_input, Opcao),
    handle_motorista_option(Opcao, MotoristaRef).

handle_motorista_option("1", MotoristaRef) :- menu_criar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option("2", MotoristaRef) :- menu_iniciar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option("3", MotoristaRef) :- menu_finalizar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option("4", MotoristaRef) :- menu_aceitar_recusar_passageiro(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option("5", MotoristaRef) :- menu_cancelar_carona_motorista(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option("6", MotoristaRef) :- menu_visualizar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option("7", MotoristaRef) :- menu_avaliar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option("0", MotoristaRef) :- menu_principal_motorista_carona(MotoristaRef).
handle_motorista_option(_, MotoristaRef) :- writeln('Opcao invalida!'), menu_principal_motorista_carona(MotoristaRef).

menu_criar_carona(MotoristaRef) :-
    MotoristaCpf = MotoristaRef,   % Retirar posteriormente
    writeln("\nCriar uma Carona"),
    write("Digite a hora (no formato HH:MM): "),
    read_line_to_string(user_input, Hora),
    write("Digite a data (no formato DD/MM/AAAA): "),
    read_line_to_string(user_input, Data),
    write("Digite a origem da viagem: "),
    read_line_to_string(user_input, Origem),
    pedir_destinos([], R),
    write("Digite o valor (use '.' para casa decimal): "),
    read_line_to_string(user_input, Valor),
    write("Digite a quantidade maximas de passageiros: "),
    read_line_to_string(user_input, NumPassageirosMaximos),
    % get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
    criar_carona(Hora, Data, [Origem|R], MotoristaCpf, Valor, NumPassageirosMaximos),
    writeln("Carona criada com sucesso!").

menu_cancelar_carona_motorista(MotoristaRef) :-
    get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
    (possui_carona_nao_iniciada_controller(MotoristaCpf) -> 
        write("Qual carona você deseja cancelar: "), nl,
        mostrar_caronas_nao_iniciadas_controller(MotoristaCpf, Caronas),
        write(Caronas), nl,
        write("Digite o Id da carona: "),
        read(Cid), nl,
        (checar_carona_de_motorista(Cid, MotoristaCpf) ->
            cancelar_carona_controller(Cid, Resposta),
            write(Resposta), nl
        ;
            write(Resposta), nl
        )
    ;
        write("Não existem caronas possíveis de se cancelar!"), nl
    ).

pedir_destinos(Destinos, R) :-
    length(Destinos, Length),
    NumNovoDestino is Length + 1,
    write('Digite a cidade numero '),
    write(NumNovoDestino),
    writeln(': (aperte apenas enter para terminar de inserir destinos) (Digite sem caracteres especiais): '),
    read_line_to_string(user_input, Destino), % Lê a entrada como uma string
    (Destino = "" ->
        R = Destinos
    ;
        atom_string(DestinoAtom, Destino), % Converte a string para um átomo
        append(Destinos, [DestinoAtom], NovosDestinos),
        pedir_destinos(NovosDestinos, R)
    ).

menu_iniciar_carona(MotoristaRef) :-
    MotoristaCpf = MotoristaRef,   % Retirar posteriormente
    % get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
    (possui_carona_nao_iniciada_controller(MotoristaCpf) -> 
        write("Qual carona voce deseja iniciar: "), nl,
        mostrar_caronas_nao_iniciadas_controller(MotoristaCpf, Caronas),
        write(Caronas),
        write("Digite o Id da carona: "),
        read_line_to_string(user_input, Cid),
        atom_number(Cid, Code),
        (checar_carona_nao_iniciada_de_motorista(MotoristaCpf, Code) ->
            inicializar_carona_status(Code),
            write("Carona iniciada com sucesso!"), nl
        ;
            write("Essa carona nao pertence a esse motorista!"), nl
        )
    ;
        write("Nao existem caronas possiveis de se iniciar!"), nl
    ).

menu_finalizar_carona(MotoristaRef) :-
    MotoristaCpf = MotoristaRef,   % Retirar posteriormente
    % get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
    (possui_carona_em_andamento_controller(MotoristaCpf) -> 
        write("Qual carona voce deseja finalizar:"), nl,
        mostrar_caronas_em_andamento_controller(MotoristaCpf, Caronas),
        write(Caronas),
        write("Digite o Id da carona: "),
        read_line_to_string(user_input, Cid),
        atom_number(Cid, Code),
        (checar_carona_em_andamento_de_motorista(MotoristaCpf, Code) ->
            finaliza_carona_status(Code),
            write("Carona finalizada com sucesso!"), nl
        ;
            write("Essa carona nao pertence a esse motorista!"), nl
        )
    ;
        write("Não existem caronas possíveis de se finalizar!"), nl
    ).

menu_aceitar_recusar_passageiro(MotoristaRef) :-
    % get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
    MotoristaCpf = MotoristaRef,
    (possui_passageiros_viagem_false_controller(MotoristaCpf) -> 
        write("Qual carona você deseja olhar os passageiros:"), nl, 
        mostrar_carona_passageiros_viagem_false(MotoristaCpf, Caronas),
        write(Caronas), nl,
        write("Digite o Id: "),
        read(Cid), nl,
        (checar_carona_passageiro_viagem_false(MotoristaCpf, Cid) -> 
            write("Qual passageiro você deseja aceitar/recusar?"), nl, 
            mostrar_carona_passageiros_viagem_false_controller(Cid, PassageirosViagem),
            write(PassageirosViagem), nl,
            write("Digite o Id: "),
            read(PVid), nl,
            (possui_passageiro_viagem_false_controller(Cid, PVid) -> 
                write("Você deseja aceitar ou recusar (Digite 'aceito' ou 'recuso'): "),
                read(PossivelAceitarOuRecusar), nl,
                verificar_aceitar_ou_recusar(PossivelAceitarOuRecusar, AceitarOuRecusar),
                aceitar_ou_recusar_passageiro_controller(PVid, AceitarOuRecusar), nl,
                (AceitarOuRecusar == 'aceito' ->
                    salvar_notificacao_passageiro(PVid, Motorista, Carona, 'aceitou voce', _)
                    writeln("Passageiro aceito com sucesso!")
                ;
                    salvar_notificacao_passageiro(PVid, Motorista, Carona, 'recusou voce', _)
                    writeln("Passageiro recusado com sucesso!")
                )             
            ;
                write("Esse passageiro não está disponivel!"), nl
            )
        ;
            write("Essa carona nao esta disponivel!"), nl
        )
    ;
        write("Nao existem caronas disponiveis para aceitar ou recusar passageiros!"), nl
    ).

verificar_aceitar_ou_recusar(AceitarOuRecusar, Retorno) :-
    downcase_atom(AceitarOuRecusar, R),
    (R == 'aceito' ; R == 'recuso' ->
        Retorno = AceitarOuRecusar
    ;
        writeln("Entrada invalida! Escreva 'aceito' ou 'recuso':"),
        readln(AceitoOuRecusado),
        verificar_aceitar_ou_recusar(AceitoOuRecusado, Retorno)
    ).

menu_visualizar_carona(MotoristaRef) :-
    get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
    (possui_carona_motorista_controller(MotoristaCpf) -> 
        write("Suas caronas disponiveis: "), nl,
        mostrar_caronas_motorista(MotoristaCpf, Caronas),
        write(Caronas), nl
    ;
        writeln("Não existem caronas disponíveis para aceitar ou recusar passageiros!")
    ).

menu_avaliar_carona(MotoristaRef) :-
    get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
    (possui_carona_sem_avaliacao_controller(MotoristaCpf) -> 
        mostrar_caronas_sem_avaliacao_motorista(MotoristaCpf, Caronas),
        write(Caronas), nl,
        write("Digite o Id da carona: "),
        read(Cid), nl,
        (checar_carona_de_motorista_avaliar(Cid, MotoristaCpf) ->
            write("Avalie a carona de 1 a 5"),
            write("Digite a avaliação: "),
            read(Avaliacao), nl,
            avaliar_carona_controller(Cid, Avaliacao),
            write("Carona avaliada com sucesso!"), nl
        ;
            write("Essa carona não pertence a esse motorista!"), nl
        )
    ;
        write("Não existem caronas disponíveis para avaliar!")
    ).
