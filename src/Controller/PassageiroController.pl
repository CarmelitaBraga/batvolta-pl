:- module(_, [
    realizar_cadastro_passageiro/8,
    remove_passageiro/3,
    atualizar_cadastro_passageiro,
    visualizar_info_passageiro,
    realizar_login_passageiro/3,
    carregar_notificacoes_passageiro
])


:- use_module('../src/Logic/PassageiroLogic.pl').

realizar_cadastro_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno):-
    cadastro_passageiro_logic(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno).

remove_passageiro(CPF, Senha, Retorno):-
    remove_passageiro_logic(CPF, Senha, Retorno).

atualizar_cadastro_passageiro():-
    atualiza_cadastro_logic().

visualizar_info_passageiro():-
    visualiza_info_logic_logic().

realizar_login_passageiro(CPF, Senha, Retorno):-
    login_passageiro_logic(CPF, Senha, Retorno).

carregar_notificacoes_passageiro():-
    carregar_notificacoes_logic().