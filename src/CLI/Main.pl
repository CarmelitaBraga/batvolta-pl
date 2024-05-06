module(_, [
   menu_principal/0,
    selecionar_opcao/1,
    menu_principal_dashboard/0,
    menu_principal_passageiro/0,
    menu_principal_motorista/0,
    menu_principal_carona/0
]).


:- use_module('DashboardCLI.pl').
:- use_module('PassageiroCLI.pl').
:- use_module('MotoristaCLI.pl').
:- use_module('CaronaCLI.pl').


menu_principal:-
    write('\nSelecione uma opção: \n'),
    write('1 - Dashboard \n'),
    write('2 - Passageiro \n'),
    write('3 - Motorista \n'),
    write('0 - Sair\n'),
    read(Opcao),
    selecionar_opcao(Opcao).

selecionar_opcao(1) :-
    menu_principal_dashboard,
    menu_principal.

selecionar_opcao(2) :-
    menu_principal_passageiro,
    menu_principal.

selecionar_opcao(3) :-
    menu_principal_motorista,
    menu_principal.

selecionar_opcao(0) :-
    write('Fim da interação!\n').

selecionar_opcao(_) :-
    write('Opção inválida!\n'),
    menu_principal.
