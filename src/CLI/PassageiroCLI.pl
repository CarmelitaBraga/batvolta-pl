:- module(passageiro_cli, [
    menu_principal/0
]).

/* Import do controller */
:- use_module("../Controller/ControllerPassageiro.pl").

:- dynamic motorista/9
:- dynamic motorista/7

/* Referencia do passageiro para login */
:- dynamic passageiro_ref/1

/* Menu de acesso do passageiro */
menu_principal:-
    write('\nSelecione uma opcao:\n'),
    write('1 - Cadastro de Passageiro\n'),
    write('2 - Login\n'),
    write('0 - Sair\n'),
    read(Opcao),
    menu_principal_opcao(Opcao).

menu_principal_opcao(1):-
    menu_cadastrar_passageiro,
    menu_principal.

menu_principal_opcao(2):-
    retractall(passageiro_ref(_)),
    assert(passageiro_ref(none)),
    menu_realizar_login,
    passageiro_ref(Passageiro),
    menu_opcoes_passageiro(Passageiro).

menu_principal_opcao(0) :-
    write('Saindo...\n').

menu_principal_opcao(_):-
    write('Opcao invalida!\n'),
    menu_principal.

menu_opcoes_passageiro(none):-
    write('\nNenhum motorista logado!\n'),
    menu_principal.

menu_opcoes_passageiro(Passageiro):-
    write('\nOpcoes do Passageiro:\n'),
    write('1 - Atualizar Cadastro\n'),
    write('2 - Cancelar Cadastro\n'),
    write('3 - Visualizar Informacoes\n'),
    write('4 - Carregar historico de Notificacoes\n'),
    write('5 - Menu de Caronas\n'),
    write('0 - Voltar ao Menu Principal\n'),
    read(Opcao),
    menu_opcoes_passageiro_opcao(Opcao, Passageiro).

menu_opcoes_passageiro_opcao(1, Passageiro):-
    menu_atualizar_cadastro(Passageiro),
    menu_opcoes_passageiro(Passageiro).

menu_opcoes_passageiro_opcao(2, Passageiro):-
    menu_cancelar_cadastro,
    menu_principal.

menu_opcoes_passageiro_opcao(3, Passageiro):-
    menu_visualizar_info(Passageiro),
    menu_opcoes_passageiro(Passageiro).

menu_opcoes_passageiro_opcao(4, Passageiro):-
    menu_carregar_notificacoes(Passageiro),
    menu_opcoes_passageiro(Passageiro).

menu_opcoes_passageiro_opcao(5, Passageiro):-
    menu_principal_carona_passageiro(Passageiro).

menu_opcoes_passageiro_opcao(0, _):-
    menu_principal.

menu_opcoes_passageiro_opcao(_, Passageiro):-
    write('Opcao invalida"\n'),
    menu_opcoes_passageiro(Passageiro)



