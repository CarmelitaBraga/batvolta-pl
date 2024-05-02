:- module(_,
        [menu_principal_passageiro_carona/1, 
        menu_procurar_carona/1, 
        menu_cancelar_carona/1, 
        menu_mostrar_caronas/1, 
        menu_desembarcar_caronas/1, 
        menu_embarcar_caronas/1, 
        menu_avaliar_motorista/1
        
        % menu_principal_motorista_carona/1,
        % menu_criar_carona/1,
        % menu_iniciar_carona/1,
        % menu_finalizar_carona/1,
        % menu_aceitar_recusar_passageiro/1,
        % menu_cancelar_carona/1,
        % menu_visualizar_carona/1,
        % menu_avaliar_carona/1
        ]).

% get_cli_cpf(PassageiroRef, PassageiroCpf).
get_cli_cpf(PassageiroRef, 11122233344).

:- use_module('src/Controller/CaronaController.pl').

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


% menu_procurar_carona(PassageiroRef):-
%     write('\nDe onde a carona deve partir?(Digite sem caracteres especiais, exemplo: ´,~,...) '),
%     read(Origem),
%     write('\nOnde a carona deve chegar?(Digite sem caracteres especiais, exemplo: ´,~,...) '),
%     read(Destino),
%     (possui_caronas_origem_destino_controller(Origem, Destino) ->
%         mostrar_caronas_disponiveis_origem_destino(Origem, Destino, Caronas),
%         write('Caronas disponíveis: '), write(Caronas), nl,
%         write('Qual carona deseja solicitar? (Digite o Id da carona ou -1 para dispensar): '),
%         read(CId),
%         (CId == -1 -> menu_principal_passageiro_carona(PassageiroRef)
%         ;
%         solicitar_carona_passageiro(CId, PassageiroRef, Origem, Destino, MaybeCaronaEscolhida),
%         write(MaybeCaronaEscolhida), nl,
%         menu_principal_passageiro_carona(PassageiroRef))
%     ;
%         write('Não existem caronas para essa origem e destino!\n'),
%         menu_principal_passageiro_carona(PassageiroRef)
%     ).


menu_cancelar_carona(PassageiroRef):-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    mostrar_viagem_passageiro(PassageiroCpf, Caronas),
    write('Caronas: \n'), write(Caronas), nl,
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
    mostrar_viagem_passageiro(PassageiroCpf, Resultado),
    write(Resultado), nl,
    menu_principal_passageiro_carona(PassageiroRef).

menu_desembarcar_caronas(PassageiroRef):- 
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    mostrar_caronas_passageiro(PassageiroCpf, Resultado),
    (Resultado \= [] ->
        write(Resultado), nl,
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
    write(Viagens), nl,
    write('Digite o ID da carona: '),
    read(IdCarona),
    embarcar_passageiro(IdCarona, PassageiroCpf, Resp),
    write(Resp), nl,
    menu_principal_passageiro_carona(PassageiroRef).

menu_avaliar_motorista(PassageiroRef) :-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    get_viagem_sem_avaliacao(PassageiroCpf, Caronas),
    (Caronas \= "" ->
        write(Caronas), nl,
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

% menu_principal_motorista_carona(MotoristaRef) :-
%     write('\nSelecione uma opção:\n'),
%     write('1 - Criar Carona\n'),
%     write('2 - Iniciar Carona\n'),
%     write('3 - Finalizar Carona\n'),
%     write('4 - Aceitar/Recusar passageiro \n'),
%     write('5 - Cancelar Carona\n'),
%     write('6 - Visualizar Caronas\n'),
%     write('7 - Avaliar Carona Finalizada\n'),
%     write('0 - Voltar\n'),
%     read(Opcao),
%     handle_motorista_option(Opcao, MotoristaRef).

% handle_motorista_option(1, MotoristaRef) :- menu_criar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(2, MotoristaRef) :- menu_iniciar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(3, MotoristaRef) :- menu_finalizar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(4, MotoristaRef) :- menu_aceitar_recusar_passageiro(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(5, MotoristaRef) :- menu_cancelar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(6, MotoristaRef) :- menu_visualizar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(7, MotoristaRef) :- menu_avaliar_carona(MotoristaRef), menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(0, MotoristaRef) :- menu_principal_motorista_carona(MotoristaRef).
% handle_motorista_option(_, MotoristaRef) :- write('Opção inválida!\n'), menu_principal_motorista_carona(MotoristaRef).

% menu_criar_carona(MotoristaRef) :-
%     write("\nCriar uma Carona"), nl,
%     write("Digite a hora (no formato HH:MM): "),
%     read(Hora), nl, 
%     write("Digite a data (no formato DD/MM/AAAA): "),
%     read(Data), nl,
%     write("Digite a origem da viagem: "),
%     read(Origem), nl,
%     pedir_destinos(Destinos), nl,
%     write("Digite o valor (use '.' para casa decimal): "),
%     read(Valor), nl, 
%     write("Digite a quantidade máximas de passageiros: "),
%     read(NumPassageirosMaximos), nl,
%     get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
%     criarCaronaMotorista (MotoristaCpf, Hora, Data, [Origem|Destinos], Valor, NumPassageirosMaximos),
%     menu_principal_motorista_carona(motoristaRef).

% pedir_destinos(Destinos) :-
%     length(Destinos, Length),
%     NumNovoDestino is Length + 1,
%     write("Digite a "),
%     write(NumNovoDestino),
%     write("ª cidade (aperte apenas enter para terminar de inserir destinos)(Digite sem caracteres especiais, exemplo: ´,~,...): "),
%     read(Destino), nl,
%     (Destino = '' ->
%     ;
%     append(Destinos, [Destino], NovosDestinos),
%     pedir_destinos(NovosDestinos)
%     ).

% menu_iniciar_carona(MotoristaRef) :-
%     get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
%     (possui_carona_nao_iniciada_controller(MotoristaCpf) -> 
%         write("Qual carona você deseja iniciar: "), nl,
%         info_caronas_nao_iniciadas_controller(MotoristaCpf, Caronas),
%         write(Caronas), nl,
%         write("Digite o Id da carona: "),
%         read(Cid), nl,
%         (checar_carona_de_motorista(Cid, MotoristaCpf) ->
%             inicializar_carona_status(Cid),
%             write("Carona iniciada com sucesso!"), nl
%         ;
%             write("Essa carona não pertence a esse motorista!"), nl
%         )
%     ;
%         write("Não existem caronas possíveis de se iniciar!"), nl
%     ),
%     menu_principal_motorista_carona(MotoristaRef).

% menu_finalizar_carona(MotoristaRef) :-
%     get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
%     (possui_carona_em_andamento_controller(MotoristaCpf) -> 
%         write("Qual carona você deseja Finalizar:"), nl,
%         info_caronas_em_andamento_controller(MotoristaCpf, Caronas),
%         write(Caronas),
%         write("Digite o Id da carona: "),
%         read(Cid), nl,
%         (checar_carona_de_motorista(Cid, MotoristaCpf) ->
%             finalizar_carona_status(Cid),
%             write("Carona finalizada com sucesso!"), nl
%         ;
%             write("Essa carona não pertence a esse motorista!"), nl
%         )
%     ;
%         write("Não existem caronas possíveis de se finalizar!"), nl
%     ),
%     menu_principal_motorista_carona(MotoristaRef).

%  menu_aceitar_recusar_passageiro(MotoristaRef) :-
%     get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
%     (possui_passageiros_viagem_false_controller(MotoristaCpf) -> 
%         write("Qual carona você deseja olhar os passageiros:"), nl, 
%         info_carona_passageiros_viagem_false(MotoristaCpf, Caronas),
%         write(Caronas), nl,
%         write("Digite o Id: "),
%         read(Cid), nl,
%         (possui_passageiro_viagem_false(MotoristaCpf, Cid) -> 
%             write("Qual passageiro você deseja aceitar/recusar?"), nl, 
%             info_passageiro_viagem_false(Cid, PassageirosViagem),
%             write(PassageirosViagens), nl,
%             write("Digite o Id: "),
%             read(PVid), nl,
%             (possui_passageiro_viagem(Cid, PVid) -> 
%                 write("Você deseja aceitar ou recusar: "),
%                 read(AceitarOuRecusar), nl,
%                 aceitar_ou_recusar_passageiro(PVid, AceitarOuRecusar), nl,
%                 insere_notificacao_passageiro_viagem(MotoristaCpf, PVid, Cid, AceitarOuRecusar),
%                 write("Passageiro aceito/recusado com sucesso!"), nl # Mudar depois
%             ;
%                 write("Esse passageiro não está disponível!"), nl
%             )
%         ;
%             write("Essa carona não está disponível!"), nl
%         )
%     ;
%         write("Não existem caronas disponíveis para aceitar ou recusar passageiros!"), nl
%     ),
%     menu_principal_motorista_carona(MotoristaRef).

% menu_cancelar_carona(MotoristaRef) :-
%     get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
%     (possui_carona_nao_iniciada_controller(MotoristaCpf) -> 
%         write("Qual carona você deseja cancelar: "), nl,
%         info_caronas_nao_iniciadas_controller(MotoristaCpf, Caronas),
%         write(Caronas), nl,
%         write("Digite o Id da carona: "),
%         read(Cid), nl,
%         (checar_carona_de_motorista(Cid, MotoristaCpf) ->
%             cancelar_carona(Cid),
%             write("Carona cancelada com sucesso!"), nl
%         ;
%             write("Essa carona não pertence a esse motorista!"), nl
%         )
%     ;
%         write("Não existem caronas possíveis de se cancelar!"), nl
%     ),
%     menu_principal_motorista_carona(MotoristaRef).

% menu_visualizar_carona(MotoristaRef) :-
%     get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
%     (possui_carona_controller(MotoristaCpf) -> 
%         write("Suas caronas disponiveis: "), nl
%         mostrar_caronas_motorista(MotoristaCpf, Caronas),
%         write(Caronas), nl
%     ;
%         write("Não existem caronas disponíveis para aceitar ou recusar passageiros!"), nl,
%     ),
%     menu_principal_motorista_carona(MotoristaRef).

% menu_avaliar_carona(MotoristaRef) :-
%     get_cli_motorista_cpf(MotoristaRef, MotoristaCpf),
%     (possui_carona_sem_avaliacao_controller(MotoristaCpf) -> 
%         mostrar_caronas_sem_avaliacao_motorista(MotoristaCpf, Caronas),
%         write(Caronas), nl,
%         write("Digite o Id da carona: "),
%         read(Cid), nl,
%         (checar_carona_de_motorista(Cid, MotoristaCpf) ->
%             write("Digite a avaliação: "),
%             read(Avaliacao), nl,
%             avaliar_carona(Cid, Avaliacao),
%             write("Carona avaliada com sucesso!"), nl
%         ;
%             write("Essa carona não pertence a esse motorista!"), nl
%         )
%     ;
%         write("Não existem caronas disponíveis para avaliar!")
%     ),
%     menu_principal_motorista_carona(MotoristaRef).