:- module(_, [
    realizar_cadastro_passageiro/8,
    remove_passageiro/3,
    atualizar_cadastro_passageiro/5,
    visualizar_info_passageiro/2,
    realizar_login_passageiro/3,
    retornar_notificacao_passageiro/2,
    salvar_notificacao_passageiro/5,
    mostrar_todos_passageiros/1,
    mostrar_passageiro_por_cpf/2
]).

:- use_module('../Logic/PassageiroLogic.pl').

realizar_cadastro_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Passageiro):-
    cadastrar_passageiro_logic(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Passageiro).

remove_passageiro(CPF, Senha, Passageiro):-
    remove_passageiro_logic(CPF, Senha, Passageiro).

atualizar_cadastro_passageiro(CPF,SenhaPassada,Coluna,NovoValor,Retorno):-
    atualiza_cadastro_logic(CPF,SenhaPassada,Coluna,NovoValor,Retorno).

visualizar_info_passageiro(CPF, Retorno):-
visualiza_info_logic(CPF, Retorno).

realizar_login_passageiro(Email, Senha, Passageiro):-
    login_passageiro_logic(Email, Senha, Passageiro).

retornar_notificacao_passageiro(CPF, Retorno):-
    recupera_notificacao_logic(CPF, Retorno).

salvar_notificacao_passageiro(Passageiro, Motorista, Carona, Conteudo, Resposta):-
    cadastra_notificacao(Passageiro, Motorista, Carona, Conteudo, Resposta).

mostrar_todos_passageiros(AllPassageiros):-
    recupera_todos_passageiros(AllPassageiros).

mostrar_passageiro_por_cpf(PassageiroCpf, Passageiro):-
    recupera_passageiro_por_cpf(PassageiroCpf, Passageiro).
