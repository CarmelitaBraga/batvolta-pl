:- module(controller_motorista, [  
    realizar_login_motorista/3,
    realizar_cadastro_motorista/10,
    cancelar_cadastro_motorista/3,
    atualizar_cadastro_motorista/5,
    visualizar_info_motorista/2,
    carregar_notificacoes_motorista/2
    
]).

realizar_login_motorista(Email, Senha, Retorno) :-
    write("Entrou realizar login motorista").

realizar_cadastro_motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao,Retorno):-
    write("Entrou Realizar cadastro motorista").

cancelar_cadastro_motorista(Cpf, Senha, Retorno):-
    write("Entrou cancelar_cadastro_motorista").

atualizar_cadastro_motorista(CPF,Coluna, NovoValor, Senha, Retorno):-
    write("Entrou atualizar cadastro motorista").

visualizar_info_motorista(cpf,retorno):-
    write("Entrou visualizar info motorista").

carregar_notificacoes_motorista(CPF, Notificacoes):-
    write("Entrou em carregar notificacoes morotista").
