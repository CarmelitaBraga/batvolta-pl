:- module(_, [menu_principal_dashboard/0]).

:- use_module('../Controller/DashboardController.pl').
:- use_module('../Util/Utils.pl').

% Main menu predicate
menu_principal_dashboard :-
    write('\nSelecione uma opcao: \n'),
    write('1 - Top-Rated Motoristas \n'),
    write('2 - Top-Rated Motoristas por Regiao \n'),
    write('3 - Top-Rated Passageiros \n'),
    write('4 - Destinos mais visitados \n'),
    write('0 - Sair\n'),
    read_line_to_string(user_input, Opcao),
    selecionar_opcao(Opcao).

% Predicate to select an option
selecionar_opcao("1") :-
    imprimirMotoristasDirijoes,
    menu_principal_dashboard.
selecionar_opcao("2") :-
    imprimirTopMotoristasPorRegiao,
    menu_principal_dashboard.
selecionar_opcao("3") :-
    imprimirTopPassageiros,
    menu_principal_dashboard.
selecionar_opcao("4") :-
    imprimirDestinosMaisVisitados,
    menu_principal_dashboard.
selecionar_opcao("0") :-
    write('Fim da interacao!\n').
selecionar_opcao(_) :-
    write('Opcao invalida!\n'),
    menu_principal_dashboard.

% Predicates for each menu option
imprimirMotoristasDirijoes :-
    buscar_melhores_motoristas(Result),
    list_to_string(Result, '', Top),
    write(Top).

imprimirTopMotoristasPorRegiao :-
    write('Digite a regiao: '),
    read_line_to_string(user_input, Regiao),
    atom_string(RegiaoStr, Regiao),
    buscar_melhores_motoristas_regiao(RegiaoStr, Result),
    list_to_string(Result, '', Top),
    write(Top).

imprimirTopPassageiros :-
    buscar_melhores_passageiros(Result),
    list_to_string(Result, '', Top),
    write(Top).

imprimirDestinosMaisVisitados :-
    write('\nTOP 5 LOCAIS MAIS USADOS COMO DESTINO: \n'),
    buscar_destinos_mais_frequentes(Result),
    write(Result).
