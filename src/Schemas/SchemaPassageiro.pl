:- module(_, [
    get_passageiro_by_cpf/2,
    get_passageiro_by_email/2,
    cadastra_passageiro/8
]).

:- dynamic passageiro/7.

:- use_module('CsvModule.pl').
% Definição do predicado passageiro/7
% passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha).

% Definição dos predicados para manipulação de passageiros

filePath(Retorno):-
    Retorno = '../../database/passageiros.csv'.

% Verifica se um CPF já está cadastrado
get_passageiro_by_cpf(CPF, Passageiro):-
    read_csv_row('../../database/passageiros.csv', 2, CPF, Row),
    Passageiro = Row.

% Verifica se um email já está cadastrado
get_passageiro_by_email(Email, Passageiro) :-
    read_csv_row('../../database/passageiros.csv', 4, Email, Row),
    Passageiro = Row.

% Cadastra um novo passageiro
% Formato cadastra_passageiro("Nome", CPF, "Genero", 'Email', "Telefone", CEP, "Senha", Retorno)
cadastra_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno) :-
    ( 
        get_passageiro_by_cpf(CPF, Passageiro), length(Passageiro, R),
        R > 0 ->  write('CPF ja cadastrado'), Retorno = 'CPF ja cadastrado' 
    ;    
        get_passageiro_by_email(Email, Passageiro), length(Passageiro, R),
        R > 0 ->  write('Email ja cadastrado'), Retorno = 'Email ja cadastrado'
    ;
        write_csv_row('../../database/passageiros.csv',[row(Nome, CPF, Genero, Email, Telefone, CEP, Senha)]),
        Retorno = "ok"
    ).


