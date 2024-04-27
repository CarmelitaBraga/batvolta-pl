:- dynamic passageiro/7

:- use_module('CsvModule.pl').

:-use_module('..Model/Passageiro.pl').

% passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha)

% Predicados para cadastro de passageiro
menu_cadastrar_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno):-
    % Verifica se o passageiro já está cadastrado
    load_passageiro_facts('../Schemas/passageiro.csv'),
    (passageiro(_, CPF, _, _, _, _, _) -> 
        write('Passageiro já cadastrado!')
    ;   % Se não estiver cadastrado, cadastra o passageiro
        passageiroToStr(passageiro(nome(Nome), cpf(CPF), genero(Genero), email(Email), telefone(Telefone), cep(CEP), senha(Senha)), PassageiroStr),
        write_csv_row('passageiro.csv', [row(Nome, CPF, Genero, Email, Telefone, CEP, Senha)]),
        assert_unique_passageiro_fact(row(Nome, CPF, Genero, Email, Telefone, CEP, Senha))
        assert(passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha)),
        Retorno = 'Passageiro cadastrado com sucesso!'
    ).

% Predicado parar remoção de passageiro
remove_passageiro(CPF):-
    retract(passageiro(_, CPF, _, _, _, _, _)).