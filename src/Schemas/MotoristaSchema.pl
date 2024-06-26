:- module(_, [
    cadastra_motorista/10,
    remove_motorista/2,
    atualiza_motorista/4,
    recupera_motoristas_por_regiao/2,
    recupera_motoristas_por_cpf/2,
    recupera_motoristas_por_email/2,
    confere_senha/2,
    confere_senha_login/2,
    get_all_motoristas/1,
    recupera_motorista_por_cpf/2
]).

:- use_module('../Schemas/CsvModuleMotorista.pl').

file('../../database/motoristas.csv').

% motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao)

%Helpers
possui_motorista(Chave):-
    file(Caminho),
    atom_number(Chave, Number),
    read_csv_row(Caminho, 1, Number, [row(_, _, _, _, _, _, _, _, _)]).

possui_motorista_email(Chave):-
    file(Caminho),
    read_csv_row(Caminho, 3, Chave, [row(_, _, _, _, _, _, _, _, _)]).

possui_cnh(Chave):-
    file(Caminho),
    read_csv_row(Caminho, 6, Chave, [row(_, _, _, _, _, _, _, _, _)]).

motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(_), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str) :-
    atomic_list_concat(['Motorista:', 'Cpf =', CPF, ',', 'Nome =', Nome, ',', 'Email =', Email,',', 'Telefone =', Telefone, ',', 'CNH =', CNH, ',', 'CEP =', CEP, ',', 'Genero =', Genero, ',', 'Regiao =', Regiao], ' ', Str).

converte_para_motorista_str(row(CPF, Nome, Email, Senha, Telefone, CNH, CEP, Genero, Regiao), Str) :-
    motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str).

cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno) :-
    ( possui_motorista(CPF) ->
        Retorno ='CPF ja cadastrado.'
    ;   
        (possui_motorista_email(Email) ->
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
    atom_number(CPF, Number),
    ( possui_motorista(CPF) ->
        file(Caminho),
        delete_csv_row(Caminho, 1, Number),
        Retorno = 'Motorista removido com sucesso.'
    ;
        Retorno = 'Motorista nao cadastrado.'
    ).

% Predicado para atualização de motorista
atualiza_motorista(Chave, Campo, NovoValor, Retorno) :-
    (possui_motorista(Chave) ->
        file(Caminho),
        atom_number(Chave, Number),
        read_csv_row(Caminho, 1, Number, [row(_, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
        delete_csv_row(Caminho,1,Number),
        (   Campo == 'telefone' -> cadastra_motorista(Chave, Nome, Email, NovoValor, Senha, CNH, CEP, Genero, Regiao,_)
        ;   Campo == 'senha' -> cadastra_motorista(Chave, Nome, Email, Telefone, NovoValor, CNH, CEP, Genero, Regiao,_)
        ;   Campo == 'cep' -> cadastra_motorista(Chave, Nome, Email, Telefone, Senha, CNH, NovoValor, Genero, Regiao,_)
        ;   Campo == 'regiao' -> cadastra_motorista(Chave, Nome, Email, Telefone, Senha, CNH, CEP, Genero, NovoValor,_)
        ;   true
        ),
        Retorno = 'Motorista atualizado com sucesso.'
    ;
        Retorno = 'Motorista nao cadastrado.'
    ). 

% Consulta para recuperar os motoristas por região
recupera_motoristas_por_regiao(Regiao, MotoristasRegiao) :-
    file(Caminho),
    read_csv_row(Caminho, 9, Regiao, MotoristasRegiao).

% Consulta para recuperar os motoristas por cpf
recupera_motoristas_por_cpf(Chave, Motorista) :-
    (possui_motorista(Chave) -> 
        file(Caminho),
        atom_number(Chave, Number),
        read_csv_row(Caminho, 1, Number, [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
        motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str),
        Motorista = Str
    ;
        Motorista = 'Motorista nao cadastrado.'
    ).

recupera_motorista_por_cpf(MotoristaCpf, Motorista):-
    file(File),
    read_csv_row(File, 1, MotoristaCpf, [Motorista|_]).

% Consulta para recuperar os motoristas por cpf
recupera_motoristas_por_email(Chave, Motorista) :-
    (possui_motorista_email(Chave) -> 
        file(Caminho),
        read_csv_row(Caminho, 3, Chave, [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
        Motorista = [CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao]
    ;
        Motorista = 'Email nao cadastrado.'
    ).

confere_senha(CPF, Senha) :-
    atom_number(CPF, Number),
    file(Caminho),
    read_csv_row(Caminho, 1, Number, [row(Number, _, _, _, SenhaCadastrada, _, _, _, _)]),
    Senha == SenhaCadastrada.

confere_senha_login(Email, Senha) :-
    file(Caminho),
    read_csv_row(Caminho, 3, Email, [row(_, _, _, _, SenhaCadastrada, _, _, _, _)]),
    Senha == SenhaCadastrada.

get_all_motoristas(ListaMotoristas):-
    file(File),
    getAllRows(File, ListaMotoristas).