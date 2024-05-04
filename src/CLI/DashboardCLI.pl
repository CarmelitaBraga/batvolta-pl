:- module(_, [menuPrincipalDashboard/0]).

:- use_module('../Controller/DashboardController.pl').

% Main menu predicate
menuPrincipalDashboard :-
    write('\nSelecione uma opção: \n'),
    write('1 - Top-Rated Motoristas \n'),
    write('2 - Top-Rated Motoristas por Região \n'),
    write('3 - Top-Rated Passageiros \n'),
    write('4 - Destinos mais visitados \n'),
    write('0 - Sair\n'),
    read(Opcao),
    selecionar_opcao(Opcao).

% Predicate to select an option
selecionar_opcao(1) :-
    imprimirMotoristasDirijoes,
    menuPrincipalDashboard.
selecionar_opcao(2) :-
    imprimirTopMotoristasPorRegiao,
    menuPrincipalDashboard.
selecionar_opcao(3) :-
    imprimirTopPassageiros,
    menuPrincipalDashboard.
selecionar_opcao(4) :-
    imprimirDestinosMaisVisitados,
    menuPrincipalDashboard.
selecionar_opcao(0) :-
    write('Fim da interação!\n'),
    menuPrincipalDashboard.
selecionar_opcao(_) :-
    write('Opção inválida!\n'),
    menuPrincipalDashboard.

% Predicates for each menu option
imprimirMotoristasDirijoes :-
    buscar_melhores_motoristas(Result),
    write(Result).

imprimirTopMotoristasPorRegiao :-
    write('Digite a região: \n'),
    read(Regiao),
    buscar_melhores_motoristas_regiao(Regiao, Result),
    write(Result).

imprimirTopPassageiros :-
    % imprimirMelhoresPassageiros(Result),
    write(Result).

imprimirDestinosMaisVisitados :-
    write('\nTOP 5 LOCAIS MAIS USADOS COMO DESTINO: \n'),
    buscar_destinos_mais_frequentes(Result),
    write(Result).
