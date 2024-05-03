:- module(_, [
    realizar_cadastro_passageiro/8,
    remove_passageiro/3,
    atualizar_cadastro_passageiro/5,
    visualizar_info_passageiro/1,
    realizar_login_passageiro/3,
    salvar_notificacao/5
]).

:- use_module('../Logic/PassageiroLogic.pl').

realizar_cadastro_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Passageiro):-
    cadastrar_passageiro_logic(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Passageiro).

remove_passageiro(CPF, Senha, Passageiro):-
    remove_passageiro_logic(CPF, Senha, Passageiro).

atualizar_cadastro_passageiro(CPF,SenhaPassada,Coluna,NovoValor,Retorno):-
    atualiza_cadastro_logic(CPF,SenhaPassada,Coluna,NovoValor,Retorno).

visualizar_info_passageiro(CPF):-
    visualiza_info_logic(CPF).

realizar_login_passageiro(Email, Senha, Passageiro):-
    login_passageiro_logic(Email, Senha, Passageiro).

retornar_notificacao(CPF,Retorno):-
    recupera_notificacao_logic(CPF,Retorno).

salvar_notificacao(Passageiro, Motorista, Carona, Conteudo, Resposta):-
    cadastra_notificacao(Passageiro, Motorista, Carona, Conteudo, Resposta).