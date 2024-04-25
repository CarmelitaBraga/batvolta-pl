:- module(_,[]).

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


menu_procurar_carona(PassageiroRef):-
    write('\nDe onde a carona deve partir?(Digite sem caracteres especiais, exemplo: ´,~,...) '),
    read(Origem),
    write('\nOnde a carona deve chegar?(Digite sem caracteres especiais, exemplo: ´,~,...) '),
    read(Destino),
    (possui_caronas_origem_destino_controller(Origem, Destino) ->
        mostrar_caronas_disponiveis_origem_destino(Origem, Destino, Caronas),
        write('Caronas disponíveis: '), write(Caronas), nl,
        write('Qual carona deseja solicitar? (Digite o Id da carona ou -1 para dispensar): '),
        read(CId),
        (CId == -1 -> menu_principal_passageiro_carona(PassageiroRef)
        ;
        solicitar_carona_passageiro(CId, PassageiroRef, Origem, Destino, MaybeCaronaEscolhida),
        write(MaybeCaronaEscolhida), nl,
        menu_principal_passageiro_carona(PassageiroRef))
    ;
        write('Não existem caronas para essa origem e destino!\n'),
        menu_principal_passageiro_carona(PassageiroRef)

    ).


menu_cancelar_carona(PassageiroRef):-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    mostrar_viagem_passageiro(PassageiroCpf, Caronas),
    write('Caronas: \n'), write(Caronas), nl,
    write('Digite o Id da carona que deseja cancelar (-1 para não escolher alguma): '),
    read(CId),
    (CId == -1 -> 
        menu_principal_passageiro_carona(PassageiroRef)
    ;
        cancelar_carona_passageiro(CId, PassageiroCpf),
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
    (Resultado =/= '\n' ->
        write(Resultado), nl,
        write('Digite o ID da carona: '),
        read(IdCarona),
        desembarcar_passageiro(IdCarona, PassageiroCpf)
    ;
        write('Nenhuma carona disponível para desembarcar!\n'),
        menu_principal_passageiro_carona(PassageiroRef)
    ).


menu_embarcar_caronas(PassageiroRef):-
    get_cli_cpf(PassageiroRef, PassageiroCpf),
    write('Escolha a carona para embarcar: \n')
    mostrar_viagem_passageiro(PassageiroCpf, Resultado),
    write(Resultado), nl,
    write('Digite o ID da carona: '),
    read(IdCarona),
    embarcar_passageiro(IdCarona, PassageiroCpf),
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
