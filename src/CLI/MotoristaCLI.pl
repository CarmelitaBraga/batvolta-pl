:- module(motorista_cli, [
    menu_principal/0
]).

% Importe Controller
:- use_module("../Controller/ControllerMotorista.pl").

:- dynamic motorista/9.
:- dynamic carona/7.

% Motorista Logado
:- dynamic motorista_ref/1.

% Implementação dos menus
menu_principal :-
    write('\nSelecione uma opcao:\n'),
    write('1 - Cadastro de Motorista\n'),
    write('2 - Login\n'),
    write('0 - Sair\n'),
    read(Opcao),
    menu_principal_opcao(Opcao).

    
menu_principal_opcao(1) :-
    menu_cadastrar_motorista,
    menu_principal.


menu_principal_opcao(2) :-
    retractall(motorista_ref(_)),
    assert(motorista_ref(none)),
    menu_realizar_login,
    motorista_ref(Motorista),
    menu_opcoes_motorista(Motorista).

menu_principal_opcao(0) :-
    write('Saindo...\n').


menu_principal_opcao(_) :-
    write('Opção inválida!\n'),
    menu_principal.


menu_opcoes_motorista(none) :-
    write('\nNenhum motorista logado!\n'),
    menu_principal.



menu_opcoes_motorista(Motorista) :-
    write('\nOpcoes do Motorista:\n'),
    write('1 - Atualizar Cadastro\n'),
    write('2 - Cancelar Cadastro\n'),
    write('3 - Visualizar Informacoes\n'),
    write('4 - Carregar historico de Notificacoes\n'),
    write('5 - Menu de Caronas\n'),
    write('0 - Sair\n'),
    read(Opcao),
    menu_opcoes_motorista_opcao(Opcao, Motorista).

menu_opcoes_motorista_opcao(1, Motorista) :-
    menu_atualizar_cadastro(Motorista),
    menu_opcoes_motorista(Motorista).

menu_opcoes_motorista_opcao(2, Motorista) :-
    menu_cancelar_cadastro,
    menu_principal.

menu_opcoes_motorista_opcao(3, Motorista) :-
    menu_visualizar_info(Motorista),
    menu_opcoes_motorista(Motorista).
    
menu_opcoes_motorista_opcao(4, Motorista) :-
    menu_carregar_notificacoes(Motorista),
    menu_opcoes_motorista(Motorista).

menu_opcoes_motorista_opcao(5, Motorista) :-
    menu_principal_carona_motorista(Motorista).

menu_opcoes_motorista_opcao(0, _) :-
    menu_principal.

menu_opcoes_motorista_opcao(_, Motorista) :-
    write('Opcao invalida!\n'),
    menu_opcoes_motorista(Motorista).

menu_cadastrar_motorista :-
    write('\nCadastrar Motorista\n'),
    write('Digite o CPF do motorista: \n'),
    read(CPF),
    write('Digite o CEP: \n'),
    read(CEP),
    write('Digite o nome: \n'),
    read(Nome),
    write('Digite o e-mail: \n'),
    read(Email),
    write('Digite o telefone: \n'),
    read(Telefone),
    write('Digite a senha: \n'),
    read(Senha),
    write('Digite a CNH: \n'),
    read(CNH),
    write('Digite a regiao: \n'),
    read(Regiao),
    write('Digite o genero(F/M/NB): \n'),
    read(Genero),
    realizar_cadastro_motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao).

menu_cancelar_cadastro :-
    motorista_ref(MotoristaRef),
    cancelar_cadastro_motorista(cpf,senha, Retorno).

menu_atualizar_cadastro(MotoristaRef) :-
    write('\nAtualizar Cadastro de Motorista\n'),
    write('Digite sua senha:'),
    read(Senha),
    write('Selecione o atributo a ser atualizado:\n'),
    write('1 - Telefone\n'),
    write('2 - Cep\n'),
    write('3 - Senha\n'),
    write('Opcao: '),
    read(Opcao),
    write('Digite o novo valor: '),
    read(NovoValor),
    (   Opcao = 1 -> atualizar_cadastro_motorista(CPF, Senha, 'telefone', NovoValor, Resultado)
    ;   Opcao = 2 -> atualizar_cadastro_motorista(CPF, Senha, 'cep', NovoValor, Resultado)
    ;   Opcao = 3 -> atualizar_cadastro_motorista(CPF, Senha, 'senha', NovoValor, Resultado)
    ;   Resultado = 'Nothing'
    ),
    (   Resultado = 'Just'(Motorista) ->
        write('Cadastro de motorista atualizado com sucesso!')
    ;   write('Erro ao atualizar cadastro de motorista.')
    ),
    menu_opcoes_motorista(MotoristaRef).

menu_visualizar_info(MotoristaRef) :-
    visualizar_info_motorista(cpf, retorno).

menu_realizar_login :-
    write('\nRealizar Login de Motorista\n'),
    write('Digite o e-mail: '),
    read(Email),
    write('Digite a senha: '),
    read(Senha),
    realizar_login_motorista(Email, Senha, Resultado),
    processar_resultado_login(Resultado).

processar_resultado_login('Just'(Motorista)) :-
    write('Login bem-sucedido!\n'),
    menu_opcoes_motorista("Motorista").

processar_resultado_login('Nothing') :-
    writeln('Login falhou!'),
    menu_principal.

menu_carregar_notificacoes(Motorista) :-
    carregar_notificacoes_motorista(MotoristaRef, Resultado).
