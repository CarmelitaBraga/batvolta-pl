:- module(motorista_cli, [
    menu_principal_motorista/0,
    menu_opcoes_motorista/0
]).

% Importe Controller
:- use_module('../Controller/MotoristaController.pl').
:- use_module('CaronaCLI.pl').

% Motorista Logado
:- dynamic motorista_logado/9.

% Implementação dos menus
menu_principal_motorista :-
    write('\nSelecione uma opcao:\n'),
    write('1 - Cadastro de Motorista\n'),
    write('2 - Login\n'),
    write('0 - Sair\n'),
    read_line_to_string(user_input, Opcao),
    menu_principal_motorista_opcao(Opcao).

menu_principal_motorista_opcao("1") :-
    menu_cadastrar_motorista.

menu_principal_motorista_opcao("2"):-
    menu_realizar_login.

menu_principal_motorista_opcao("0") :-
    write('Saindo...\n').

menu_principal_motorista_opcao(_) :-
    write('Opcao invalida!\n'),
    menu_principal_motorista.

menu_cadastrar_motorista :-
    write('\nCadastrar Motorista\n'),
    write('Digite o CPF do motorista (somente numeros): \n'),
    read_line_to_string(user_input, CPF),
    write('Digite o nome: \n'),
    read_line_to_string(user_input, Nome),
    atom_string(NomeStr, Nome),
    write('Digite o e-mail: \n'),
    read_line_to_string(user_input, Email),
    atom_string(EmailStr, Email),
    write('Digite o telefone: \n'),
    read_line_to_string(user_input, Telefone),
    atom_string(TelefoneStr, Telefone),
    write('Digite a senha: (letras e numeros) \n'),
    read_line_to_string(user_input, Senha),
    atom_string(SenhaStr, Senha),
    write('Digite a CNH: \n'),
    read_line_to_string(user_input, CNH),
    atom_string(CNHStr, CNH),
    write('Digite o CEP: \n'),
    read_line_to_string(user_input, CEP),
    atom_string(CEPStr, CEP),
    write('Digite a regiao: (em minusculo)\n'),
    read_line_to_string(user_input, Regiao),
    atom_string(RegiaoStr, Regiao),
    write('Digite o genero(F/M/NB): \n'),
    read_line_to_string(user_input, Genero),
    atom_string(GeneroStr, Genero),
    realizarCadastroMotorista(CPF, NomeStr, EmailStr, TelefoneStr, SenhaStr, CNHStr, CEPStr, GeneroStr, RegiaoStr,Resposta),
    write(Resposta).

menu_realizar_login :-
    write('\nRealizar Login de Motorista\n'),
    write('Digite o e-mail:\n'),
    read_line_to_string(user_input, Email),
    atom_string(EmailStr, Email),
    write('Digite a senha:\n'),
    read_line_to_string(user_input, Senha),
    atom_string(SenhaStr, Senha),
    realizarLoginMotorista(EmailStr, SenhaStr, Resultado),
    processar_resultado_login(Resultado).

processar_resultado_login([CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao]) :-
    write('Login bem-sucedido!\n'),
    retractall(motorista_logado(_, _, _, _, _, _, _, _, _)),
    assertz(motorista_logado(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)),
    menu_opcoes_motorista.

processar_resultado_login('Login incorreto.') :-
    writeln('Login falhou!'),
    menu_principal_motorista.

menu_opcoes_motorista :-
    write('\nOpcoes do Motorista:\n'),
    write('1 - Atualizar Cadastro\n'),
    write('2 - Cancelar Cadastro\n'),
    write('3 - Visualizar Informacoes\n'),
    write('4 - Carregar historico de Notificacoes\n'),
    write('5 - Menu de Caronas\n'),
    write('0 - Sair\n'),
    read_line_to_string(user_input, Opcao),
    menu_opcoes_motorista_opcao(Opcao).

menu_opcoes_motorista_opcao("1") :-
    menu_atualizar_cadastro,
    menu_opcoes_motorista.

menu_opcoes_motorista_opcao("2") :-
    menu_cancelar_cadastro,
    retractall(motorista_logado(_, _, _, _, _, _, _, _, _)),
    menu_principal_motorista.

menu_opcoes_motorista_opcao("3") :-
    menu_visualizar_info,
    menu_opcoes_motorista.

menu_opcoes_motorista_opcao("4") :-
    menu_carregar_notificacoes.

menu_opcoes_motorista_opcao("5") :-
    motorista_logado(CPF, _, _, _, _, _, _, _, _),
    menu_principal_motorista_carona(CPF),
    menu_opcoes_motorista. 

menu_opcoes_motorista_opcao("0") :-
    retractall(motorista_logado(_, _, _, _, _, _, _, _, _)),
    menu_principal_motorista.

menu_opcoes_motorista_opcao(_) :-
    write('Opcao invalida!\n'),
    menu_opcoes_motorista.

menu_cancelar_cadastro :-
    write('Digite a senha: \n'),
    read_line_to_string(user_input, Senha),
    atom_string(SenhaStr, Senha),
    motorista_logado(CPF, _, _, _, _, _, _, _, _),
    cancelarCadastroMotorista(CPF,SenhaStr, Retorno),
    write(Retorno). 

menu_atualizar_cadastro :-
    motorista_logado(CPF, _, _, _, _, _, _, _, _),
    write('\nAtualizar Cadastro de Motorista\n'),
    write('Digite sua senha:\n'),
    read_line_to_string(user_input, Senha),
    atom_string(SenhaStr, Senha),
    write('Selecione o atributo a ser atualizado:\n'),
    write('1 - Telefone\n'),
    write('2 - Cep\n'),
    write('3 - Senha\n'),
    write('Opcao: \n'),
    read_line_to_string(user_input, Opcao),
    write('Digite o novo valor: \n'),
    read_line_to_string(user_input, NovoValor),
    atom_string(NovoValorStr, NovoValor),
    (   Opcao = "1" -> atualizarCadastroMotorista(CPF, SenhaStr, 'telefone', NovoValorStr, Resultado)
    ;   Opcao = "2" -> atualizarCadastroMotorista(CPF, SenhaStr, 'cep', NovoValorStr, Resultado)
    ;   Opcao = "3" -> atualizarCadastroMotorista(CPF, SenhaStr, 'senha', NovoValorStr, Resultado)
    ),
    write(Resultado),
    menu_opcoes_motorista.

menu_visualizar_info:-
    motorista_logado(CPF, _, _, _, _, _, _, _, _),
    recuperarMotoristaPorCPF(CPF, Retorno),
    write(Retorno).

menu_carregar_notificacoes :-
    motorista_logado(CPF, _, _, _, _, _, _, _, _),
    recuperarNotificao(CPF, Resultado),
    write(Resultado),
    menu_opcoes_motorista.
