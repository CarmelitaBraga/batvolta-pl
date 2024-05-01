:- module(controller_motorista, [  
    realizar_login_motorista/3,
    realizar_cadastro_motorista/10,
    cancelar_cadastro_motorista/3,
    atualizar_cadastro_motorista/5,
    visualizar_info_motorista/2,
    carregar_notificacoes_motorista/2
    
]).

:- use_module('../Logic/MotoristaLogic.pl').

realizarCadastroMotorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno):-
    cadastra_Logic(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Resposta),
    Retorno = Resposta.

cancelarCadastroMotorista(CPF, Senha,Retorno):-
    remove_Logic(CPF,Senha, Resposta),
    Retorno = Resposta.

atualizarCadastroMotorista(CPF, Senha, Campo, NovoValor, Retorno):-
    atualiza_Logic(CPF, Campo, Resposta),
    Retorno = Resposta.

recuperarMotoristasPorRegiao(Regiao, Motoristas):-
    recupera_motoristas_por_regiao(Regiao, Resposta),
    Motoristas = Resposta.

recuperarMotoristaPorCPF(CPF, Motorista):-
    recupera_motoristas_por_cpf(CPF, Resposta),
    Motorista = Resposta.