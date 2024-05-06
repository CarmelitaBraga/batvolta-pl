:- module(_, [
    existe_passageiro_by_cpf/1,
    existe_passageiro_by_email/1,
    cadastra_passageiro/8,
    remove_passageiro/2,
    atualiza_passageiro/4,
    get_passageiro_by_cpf/2,
    get_passageiro_by_email/2,
    confere_senha/2,
    passageiro_to_string/2
]).

:- dynamic passageiro/7.

:- use_module('CsvModule.pl').
% Definição do predicado passageiro/7
% passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha).

% Definição dos predicados para manipulação de passageiros

filePath(Retorno):-
    Retorno = '../../database/passageiros.csv'.

existe_passageiro_by_cpf(CPF):-
    filePath(File),
    read_csv_row(File, 2, CPF, [row(_, CPF, _, _, _, _, _)]).

existe_passageiro_by_email(Email) :-
    filePath(File),
    read_csv_row(File, 4, Email, [row(_, _, _, Email, _, _, _)]).

% Cadastra um novo passageiro
% Formato cadastra_passageiro('Nome', CPF, 'Genero', 'Email', Telefone, CEP, 'Senha', Retorno)
cadastra_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno) :-
    filePath(File),
    (   existe_passageiro_by_cpf(CPF) ->
        Retorno = "CPF ja cadastrado." 
    ;    
        existe_passageiro_by_email(Email) ->
        Retorno = "Email ja cadastrado."
    ;
        downcase_atom(Genero, G)
        write_csv_row(File,[row(Nome, CPF, G, Email, Telefone, CEP, Senha)]),
        Retorno = 'Passageiro cadastrado com sucesso.'
    ).
% cadastra_passageiro('Caique',12345678901,'M','caique@gmail.com',12345678901,12345678,12345678,Retorno).
remove_passageiro(CPF, Retorno) :-
    filePath(File),
    (delete_csv_row_bool(File, 2, CPF) ->
        Retorno = 'Passageiro removido com sucesso.'
    ;
        Retorno = 'Passageiro nao encontrado.'
    ). 
% Campo = 1 para telefone
% Campo = 2 para CEP
% Campo = 3 para senha
atualiza_passageiro(CPF, Campo, NovoValor, Retorno) :-
    filePath(File),
    (   existe_passageiro_by_cpf(CPF) ->
        read_csv_row(File, 2, CPF, [row(Nome,CPF,Genero,Email,Telefone,CEP,Senha)]),
        (   (Campo \= 1, Campo \= 2, Campo \= 3)
            -> Retorno = 'Campo inválido.'
        ;
            delete_csv_row_bool(File, 2, CPF),
            (   Campo == 1 -> cadastra_passageiro(Nome, CPF, Genero, Email, NovoValor, CEP, Senha, _)
            ;   Campo == 2 -> cadastra_passageiro(Nome, CPF, Genero, Email, Telefone, NovoValor, Senha, _)
            ;   Campo == 3 -> cadastra_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, NovoValor, _)
            ),
            Retorno = 'Passageiro atualizado com sucesso.'
        )
    ;   
        Retorno = 'Passageiro não encontrado.'
    ).

get_passageiro_by_cpf(CPF, Retorno) :-
    filePath(File),
    (   existe_passageiro_by_cpf(CPF) ->
        read_csv_row(File, 2, CPF, [row(Nome,CPF,Genero,Email,Telefone,CEP,Senha)]),
        Retorno = [Nome,CPF,Genero,Email,Telefone,CEP,Senha]
    ;   
        Retorno = false
    ).

get_passageiro_by_email(Email, Retorno) :-
    filePath(File),
    (   existe_passageiro_by_email(Email) ->
        read_csv_row(File, 4, Email, [row(Nome,CPF,Genero,Email,Telefone,CEP,Senha)]),
        Retorno = [Nome,CPF,Genero,Email,Telefone,CEP,Senha]
    ;   
        Retorno = false
    ).

passageiro_to_string([Nome,CPF,Genero,Email,Telefone,CEP,Senha], Retorno) :-
    atomic_list_concat(['Passageiro:\n', 'Nome =', Nome, '\n', 'CPF =', CPF, '\n', 'Genero =', Genero, '\n', 'Email =', Email,'\n', 'Telefone =', Telefone, '\n',  'CEP =', CEP,'\n', 'Senha =', Senha, '\n'], ' ', Retorno).

confere_senha(SenhaPassada, SenhaPassageiro):-
    SenhaPassada == SenhaPassageiro.
    