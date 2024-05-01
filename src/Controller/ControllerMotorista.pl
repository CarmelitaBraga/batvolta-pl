:- module(controller_motorista, [  
   % realizar_login_motorista/3,
   realizarCadastroMotorista/10,
   cancelarCadastroMotorista/3,
   atualizarCadastroMotorista/5,
   recuperarMotoristaPorCPF/2,
   recuperarNotificao/2
    
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

recuperarNotificao(CPF, Notificacao):-
    recupera_notificacao_logic(CPF, Notificacao).
