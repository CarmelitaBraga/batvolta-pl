module(_, [
    menu_principal/0,
    seleciona_opcao/1,
    menu_principal_dashboard/0,
    menu_principal_passageiro/0,
    menu_principal_motorista/0,
    menu_principal_carona/0
]).


:- use_module('DashboardCLI.pl').
:- use_module('PassageiroCLI.pl').
:- use_module('MotoristaCLI.pl').
:- use_module('CaronaCLI.pl').

:- initialization(menu_principal).

menu_principal:-
    write('\n\n========== Bem vindo(a) ao BatVolta ==========\n\n'),
    write('\nSelecione uma alternativa: \n'),
    write('1 - Dashboard \n'),
    write('2 - Passageiro \n'),
    write('3 - Motorista \n'),
    write('0 - Sair\n'),
    read_line_to_string(user_input, Opcao),
    seleciona_opcao(Opcao).

seleciona_opcao("1") :-
    menu_principal_dashboard,
    menu_principal.

seleciona_opcao("2") :-
    menu_principal_passageiro,
    menu_principal.

seleciona_opcao("3") :-
    menu_principal_motorista,
    menu_principal.

seleciona_opcao("0") :-
    write('Fim da interação!\n\n').

seleciona_opcao(_) :-
    write('Opção inválida!\n'),
    menu_principal.
