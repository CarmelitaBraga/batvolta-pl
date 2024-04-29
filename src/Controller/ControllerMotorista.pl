:- module(controller_motorista, [  
    realizar_login_motorista/3,
    realizar_cadastro_motorista/10,
    cancelar_cadastro_motorista/3,
    atualizar_cadastro_motorista/5,
    visualizar_info_motorista/2,
    carregar_notificacoes_motorista/2
    
]).


realizarCadastroMotorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno):-
    cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno).

cancelarCadastroMotorista(CPF, Retorno):-
    remove_motorista(CPF, Retorno).

atualizarCadastroMotorista(CPF, Campo, NovoValor):-
    atualiza_motorista(CPF, Campo, NovoValor).

recuperarMotoristasPorRegiao(Regiao, Motoristas):-
    recupera_motoristas_por_regiao(Regiao, Motoristas).

recuperarMotoristaPorCPF(CPF, Motorista):-
    recupera_motoristas_por_cpf(CPF, Motorista).
    

