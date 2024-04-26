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
    menu_opcoes_passageiro(Passageiro).

menu_cadastrar_passageiro:-
    write('\nCadastrar Passageiro\n'),
    write('Digite o Nome: \n'),
    read(Nome),
    write('Digite o CPF: \n'),
    read(CPF),
    write('Digite o Genero (F/M/NB): \n'),
    read(Genero),
    write('Digite o E-mail: \n'),
    read(Email),
    write('Digite o Telefone: \n'),
    read(Telefone),
    write('Digite o CEP: \n'),
    read(CEP),
    write('Digite a Senha: \n'),
    read(Senha),
    realizar_cadastro_passageiro(Nome, CPF, Genero, email, Telefone, CEP, Senha).

menu_cancelar_cadastro:-
    passageiro_ref(Passageiro_ref),
    cancelar_cadastro_passageiro(CPF,Senha, Retorno).

menu_atualizar_cadastro(Passageiro_ref):-
    write('\nAtualizar Cadastro de Passageiro\n'),
    write('Digite sua senha: '),
    read(Senha),
    write('Selecione o campo a ser atualizado:\n'),
    write('1 - Telefone\n'),
    write('2 - Cep\n'),
    write('3 - Senha\n'),
    write('Opcao: '),
    read(Opcao),
    write('Digite o novo valor: '),
    read(NovoValor),
    (   Opcao = 1 -> atualizar_cadastro_passageiro(CPF, Senha, 'Telefone', NovoValor, Resultado)
    ;   Opcao = 2 -> atualizar_cadastro_passageiro(CPF, Senha, 'Cep', NovoValor, Resultado)
    ;   Opcao = 3 -> atualizar_cadastro_passageiro(CPF, Senha, 'Senha', NovoValor, Resultado)
    ;   Resultado = 'Opcao invalida'
    ),
    (   Resultado = 'Just' (Passageiro) ->
        write('Cadastro atualizado com sucesso!\n')
    ;   write('Erro ao atualizar cadastro!\n')
    ),
    menu_opcoes_passageiro(Passageiro_ref).

menu_visualizar_info(Passageiro_ref):-
    visualizar_info_passageiro(cpf, retorno).

menu_realizar_login:-
    write('\nRealizar Login de Passageiro\n'),
    write('Digite o e-mail: '),
    read(Email),
    write('Digite a senha: '),
    read(Senha),
    realizar_login_passageiro(Email, Senha, Resultado),
    processar_resultado_login(Resultado).

processar_resultado_login('Just'(Passageiro)):-
    write('Login realizado com sucesso!\n'),
    menu_opcoes_passageiro("Passageiro").

processar_resultado_login('Nothing'):-
    write('Login falhou!\n'),
    menu_principal.

menu_carregar_notificacoes(Passageiro):-
    carregar_notificacoes_passageiro(Passageiro_ref, Notificacoes).
    

