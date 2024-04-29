:- module(_, [
    cadastra_motorista/10,
    remove_motorista/2,
    atualiza_motorista/4,
    recupera_motoristas_por_regiao/2,
    recupera_motoristas_por_cpf/2
]).

:- use_module("CsvModule.pl").
:- use_module("../Model/MotoristaModel.pl").

% motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao)

%Helpers
possui_motorista(Chave):-
    file(Caminho),
    read_csv_row(Caminho, 1, Chave, [row(_, _, _, _, _, _, _, _, _)]).

possui_motorista_email(Chave):-
    file(Caminho),
    read_csv_row(Caminho, 3, Chave, [row(_, _, _, _, _, _, _, _, _)]).

possui_cnh(Chave):-
    file(Caminho),
    read_csv_row(Caminho, 6, Chave, [row(_, _, _, _, _, _, _, _, _)]).

converte_para_motorista_str(row(CPF, Nome, Email, Senha, Telefone, CNH, CEP, Genero, Regiao), Str) :-
    motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str).

file(Retorno):-
    Retorno = '../../database/motoristas.csv'.

% Predicados para cadastro de motorista
cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno) :-
    % Verificar se o CPF já está cadastrado
    ( possui_motorista(CPF) ->
        Retorno ='CPF ja cadastrado.'
    ;   
        (possui_motorista_email(email) ->
            Retorno = 'Email ja cadastrado.'
        ;
            (possui_cnh(CNH) ->
                Retorno = 'CNH ja cadastrada.'
                ;   
                    file(Caminho),
                    write_csv_row(Caminho, [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
                    Retorno = 'Cadastro realizado com sucesso.'
            )   
        )
    ).


% Predicado para remoção de motorista
remove_motorista(CPF, Retorno) :-
    ( possui_motorista(CPF) ->
        file(Caminho),
        delete_csv_row(Caminho, 1, CPF),
        Retorno = 'Motorista removido com sucesso.'
    ;
        Retorno = 'Motorista nao cadastrado.'
    ).

% Predicado para atualização de motorista
atualiza_motorista(Chave, Campo, NovoValor, Retorno) :-
    (possui_motorista(Chave) ->
        file(Caminho),
        read_csv_row(Caminho, 1, Chave, [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
        delete_csv_row(Caminho,1,Chave),
        (   Campo == 'telefone' -> cadastra_motorista(CPF, Nome, Email, NovoValor, Senha, CNH, CEP, Genero, Regiao,_)
        ;   Campo == 'senha' -> cadastra_motorista(CPF, Nome, Email, Telefone, NovoValor, CNH, CEP, Genero, Regiao,_)
        ;   Campo == 'cep' -> cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, NovoValor, Genero, Regiao,_)
        ;   Campo == 'regiao' -> cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, NovoValor,_)
        ;   true
        ),
        Retorno = 'Motorista atualizado com sucesso.'
    ;
        Retorno = 'Motorista nao cadastrado.'
    ). 

% Consulta para recuperar os motoristas por região
recupera_motoristas_por_regiao(Regiao, MotoristasStr) :-
    file(Caminho),
    read_csv_row(Caminho, 9, Regiao, MotoristasData),
    maplist(converte_para_motorista_str, MotoristasData, MotoristasStr).

% Consulta para recuperar os motoristas por cpf
recupera_motoristas_por_cpf(Chave, Motorista) :-
    (possui_motorista(Chave) -> 
        file(Caminho),
        read_csv_row(Caminho, 1, Chave, [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
        motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str),
        Motorista = Str
    ;
        Motorista = 'Motorista nao cadastrado.'
    ).

% Consulta para recuperar os motoristas por cpf
recupera_motoristas_por_email(Chave, Motorista) :-
    (possui_motorista(Chave) -> 
        file(Caminho),
        read_csv_row(Caminho, 3, Chave, [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
        Motorista = [CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao]
    ;
        Motorista = 'Motorista nao cadastrado.'
    ).


confere_senha(CPF, Senha) :-
    file(Caminho),
    read_csv_row(Caminho, 5, Senha, [row(CPF, _, _, _, SenhaCadastrada, _, _, _, _)]),
    Senha == SenhaCadastrada.
