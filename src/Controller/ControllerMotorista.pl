:- module(controller_motorista, [  
    realizarLoginMotorista/3,
   realizarCadastroMotorista/10,
   cancelarCadastroMotorista/3,
   atualizarCadastroMotorista/5,
   recuperarMotoristaPorCPF/2,
   recuperarNotificao/2,
   recuperarMotoristasPorRegiao/2
    
]).

:- use_module('../Logic/MotoristaLogic.pl').

realizarCadastroMotorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno):-
    cadastra_Logic(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno).

cancelarCadastroMotorista(CPF, Senha,Retorno):-
    remove_Logic(CPF,Senha, Retorno).

atualizarCadastroMotorista(CPF, Senha, Campo, NovoValor, Retorno):-
    atualiza_Logic(CPF, Senha, Campo, NovoValor, Retorno).

recuperarMotoristasPorRegiao(Regiao, Motoristas):-
    recupera_regiao_logic(Regiao, Motoristas).

recuperarMotoristaPorCPF(CPF, Motorista):-
    recupera_cpf_logic(CPF, Motorista).

recuperarNotificao(CPF, Notificacao):-
    recupera_notificacao_logic(CPF, Notificacao).

realizarLoginMotorista(Email,Senha,Motorista):-
    realiza_login_logic(Email,Senha,Motorista).