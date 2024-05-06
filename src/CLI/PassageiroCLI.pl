:- module(_, [
    menu_principal_passageiro/0,
    menu_opcoes_passageiro/0
]).

/* Import do controller */
:- use_module('../Controller/PassageiroController.pl').
:- use_module('CaronaCLI.pl').

/* Referencia do passageiro para login */
:- dynamic passageiro_logado/7.

/* Menu de acesso do passageiro */

menu_principal_passageiro:-
    write('\nSelecione uma opcao:\n'),
    write('1 - Cadastro de Passageiro\n'),
    write('2 - Login\n'),
    write('0 - Sair\n'),
    read_line_to_string(user_input,Opcao),
    menu_principal_opcao(Opcao).
    
menu_principal_opcao("1"):-
    menu_cadastrar_passageiro,
    menu_principal_passageiro.

menu_principal_opcao("2"):-
    menu_realizar_login.

menu_principal_opcao("0") :-
    write('Saindo...\n').

menu_principal_opcao(_):-
    write('Opcao invalida!\n'),
    menu_principal_passageiro.

menu_cadastrar_passageiro():-
    write('\nCadastrar Passageiro\n'),
    write('Digite o Nome: \n'),
    read_line_to_string(user_input,Nome),
    atom_string(NomeStr, Nome),
    write('Digite o CPF: (somente numeros) \n'),
    read_line_to_string(user_input,CPF),
    write('Digite o Genero: (F|M|NB) \n'),
    read_line_to_string(user_input,Genero),
    atom_string(GeneroStr, Genero),
    write('Digite o E-mail: \n'),
    read_line_to_string(user_input,Email),
    atom_string(EmailStr, Email),
    write('Digite o Telefone: \n'),
    read_line_to_string(user_input,Telefone),
    atom_string(TelefoneStr, Telefone),
    write('Digite o CEP: \n'),
    read_line_to_string(user_input,CEP),
    atom_string(CEPStr, CEP),
    write('Digite a Senha: \n'),
    read_line_to_string(user_input,Senha),
    atom_string(SenhaStr, Senha),
    realizar_cadastro_passageiro(NomeStr, CPF, GeneroStr, EmailStr, TelefoneStr, CEPStr, SenhaStr, Retorno),
    write(Retorno), nl.

menu_realizar_login():-
    write('\nRealizar Login de Passageiro\n'),
    write('Digite o e-mail: \n'),
    read_line_to_string(user_input, Email),
    atom_string(EmailStr, Email),
    write('Digite a senha: \n'),
    read_line_to_string(user_input,Senha),
    atom_string(SenhaStr, Senha),
    realizar_login_passageiro(EmailStr, SenhaStr, Passageiro),
    processar_resultado_login(Passageiro).

processar_resultado_login([Nome, CPF, Genero, Email, Telefone, CEP, Senha]):-
    write('Login realizado com sucesso!\n'),
    retractall(passageiro_logado(_, _, _, _, _, _, _)),
    assert(passageiro_logado(Nome, CPF, Genero, Email, Telefone, CEP, Senha)),
    menu_opcoes_passageiro.

processar_resultado_login(_):-
    write('Login falhou!\n'),
    menu_principal_passageiro.

menu_opcoes_passageiro:-
    write('\nOpcoes do Passageiro:\n'),
    write('1 - Atualizar Cadastro\n'),
    write('2 - Cancelar Cadastro\n'),
    write('3 - Visualizar Informacoes\n'),
    write('4 - Carregar historico de Notificacoes\n'),
    write('5 - Menu de Caronas\n'),
    write('0 - Voltar ao Menu Principal\n'),
    read_line_to_string(user_input,Opcao),
    menu_opcoes_passageiro_opcao(Opcao).

menu_opcoes_passageiro_opcao("1"):-
    menu_atualizar_cadastro,
    menu_opcoes_passageiro.

menu_opcoes_passageiro_opcao("2"):-
    menu_cancelar_cadastro,
    retractall(passageiro_logado(_, _, _, _, _, _, _, _, _)),
    menu_principal_passageiro.

menu_opcoes_passageiro_opcao("3"):-
    menu_visualizar_info,
    menu_opcoes_passageiro.

menu_opcoes_passageiro_opcao("4"):-
    menu_carregar_notificacoes(),
    menu_opcoes_passageiro.

menu_opcoes_passageiro_opcao("5"):-
    passageiro_logado(_, CPF, _, _, _, _, _),
    menu_principal_passageiro_carona(CPF),
    menu_opcoes_passageiro.

menu_opcoes_passageiro_opcao("0"):-
    retractall(passageiro_logado(_, _, _, _, _, _, _, _, _)),
    menu_principal_passageiro.

menu_opcoes_passageiro_opcao(_):-
    write('Opcao invalida\n'),
    menu_opcoes_passageiro.

% menu_atualizar_cadastro:-
%     passageiro_logado(_, CPF, _, _, _, _, _),
%     write('\nAtualizar Cadastro de Passageiro\n'),
%     write('Digite sua senha: \n'),
%     read_line_to_string(user_input, Senha),
%     atom_string(SenhaStr, Senha),
%     write('Selecione o campo a ser atualizado:\n'),
%     write('1 - Telefone\n'),
%     write('2 - Cep\n'),
%     write('3 - Senha\n'),
%     write('Opcao: \n'),
%     read_line_to_string(user_input,Opcao),
%     write('Digite o novo valor: \n'),
%     read_line_to_string(user_input,NovoValor),
%     atom_string(NovoValorStr, NovoValor),
%     % BIG WARNING aqui!!!!!!!!!!!!!!!!!!!!!!!!!!
%     atualizar_cadastro_passageiro(CPF, Senha, Opcao, NovoValorStr, Resultado),
%     write(Resultado), nl,
%     menu_opcoes_passageiro.

menu_atualizar_cadastro:-
    passageiro_logado(_, CPF, _, _, _, _, _),
    write('\nAtualizar Cadastro de Passageiro\n'),
    write('Digite sua senha: \n'),
    read_line_to_string(user_input, Senha),
    atom_string(SenhaStr, Senha),
    write('Selecione o campo a ser atualizado:\n'),
    write('1 - Telefone\n'),
    write('2 - Cep\n'),
    write('3 - Senha\n'),
    write('Opcao: \n'),
    read_line_to_string(user_input, Opcao),
    write('Digite o novo valor: \n'),
    read_line_to_string(user_input, NovoValor),
    atom_string(NovoValorStr, NovoValor),
    (   Opcao = "1" -> atualizar_cadastro_passageiro(CPF, SenhaStr, 'telefone', NovoValorStr, Resultado)
    ;   Opcao = "2" -> atualizar_cadastro_passageiro(CPF, SenhaStr, 'cep', NovoValorStr, Resultado)
    ;   Opcao = "3" -> atualizar_cadastro_passageiro(CPF, SenhaStr, 'senha', NovoValorStr, Resultado)
    ),
    write(Resultado), nl,
    menu_opcoes_passageiro.


menu_visualizar_info:-
    passageiro_logado(_, CPF, _, _, _, _, _),
    visualizar_info_passageiro(CPF, Retorno),
    write(Retorno), nl,
    menu_opcoes_passageiro.

menu_cancelar_cadastro:-
    passageiro_logado(_, CPF, _, _, _, _, _),
    write('Digite a senha: \n'),
    read_line_to_string(user_input,Senha),
    atom_string(SenhaStr, Senha),
    (  remove_passageiro(CPF,SenhaStr, Retorno),
        Retorno = 'Senha incorreta.'
        ->  write(Retorno), nl,
            menu_opcoes_passageiro
        ;
            write('Cadastro cancelado com sucesso.'), nl,
            menu_opcoes_passageiro_opcao(0)
    ).

menu_carregar_notificacoes():-
    passageiro_logado(_, CPF, _, _, _, _, _),
    atom_string(CPF, CPFString),
    retornar_notificacao_passageiro(CPFString, Retorno),
    write(Retorno), nl.