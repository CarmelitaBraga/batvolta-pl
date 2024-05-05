module(_, [
   menuPrincipal/0,
    selecionar_opcao/1,
    menuPrincipalDashboard/0,
    menuPrincipalPassageiro/0,
    menuPrincipalMotorista/0,
    menuPrincipalCarona/0
]).


:- use_module('DashboardCLI.pl').
:- use_module('PassageiroCLI.pl').
:- use_module('MotoristaCLI.pl').
:- use_module('CaronaCLI.pl').


menuPrincipal:-
    write('\nSelecione uma opção: \n'),
    write('1 - Dashboard \n'),
    write('2 - Passageiro \n'),
    write('3 - Motorista \n'),
    write('4 - Carona \n'),
    write('0 - Sair\n'),
    read(Opcao),
    selecionar_opcao(Opcao).

selecionar_opcao(1) :-
    menuPrincipalDashboard,
    menuPrincipal.

selecionar_opcao(2) :-
    menu_principal_passageiro,
    menuPrincipal.

selecionar_opcao(3) :-
    menu_principal_motorista,
    menuPrincipal.

selecionar_opcao(4) :-
    chamarMenuCarona,
    menuPrincipal.

selecionar_opcao(0) :-
    write('Fim da interação!\n').

selecionar_opcao(_) :-
    write('Opção inválida!\n'),
    menuPrincipal.
