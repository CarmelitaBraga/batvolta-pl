:- dynamic motorista/9.

:- use_module("CsvModule.pl").
:- use_module("../Model/MotoristaModel.pl").

% motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao)


file(Retorno):-
    Retorno = '../../database/motoristas.csv'.

% Predicados para cadastro de motorista
cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno) :-
    % Verificar se o CPF já está cadastrado
    ( motorista(CPF, _, _, _, _, _, _, _, _) ->
        Retorno ='CPF já cadastrado'
    ; motorista(_, _, _, _, _, _, CNH, _, _) ->
        Retorno = 'CNH já cadastrada'
        ;
            %Se não estiver cadastrado, realizar o cadastro
            motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str),
            assert(motorista(CPF,Nome,Email,Senha,Telefone,CNH,CEP,Genero,Regiao)),
            write_csv_row('../../database/motoristas.csv', [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
            Retorno = 'Cadastro realizado com sucesso'
    ).


% Predicado para remoção de motorista
remove_motorista(CPF, Retorno) :-
    file(Caminho),
    delete_csv_row(Caminho, 1, CPF),
    Retorno = 'Motorista removido com sucesso.'.
  

% Predicado para atualização de motorista
atualiza_motorista(Chave, Campo, NovoValor, Retorno) :-
    file(Caminho),
    % Recupera os detalhes do motorista por CPF
    read_csv_row(Caminho, 1, Chave, [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
    write('sim'),
    delete_csv_row(Caminho,1,Chave),
    % Atualiza apenas o campo desejado
    (   Campo == 'telefone' -> write_csv_row(Caminho,[CPF, Nome, Email, NovoValor, Senha, CNH, CEP, Genero, Regiao])
    ;   Campo == 'senha' -> write_csv_row(Caminho, [CPF, Nome, Email, Telefone, NovoValor, CNH, CEP, Genero, Regiao])
    ;   Campo == 'cnh' -> write_csv_row(Caminho, [CPF, Nome, Email, Telefone, Senha, NovoValor, CEP, Genero, Regiao])
    ;   Campo == 'cep' -> write_csv_row(Caminho, [CPF, Nome, Email, Telefone, Senha, CNH, NovoValor, Genero, Regiao])
    ;   Campo == 'genero' -> write_csv_row(Caminho, [CPF, Nome, Email, Telefone, Senha, CNH, CEP, NovoValor, Regiao])
    ;   Campo == 'regiao' -> write_csv_row(Caminho, [CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, NovoValor])
    ;   true
    ).  

% Predicado para recuperar todos os motoristas de uma determinada região
recupera_motoristas_por_regiao(Regiao, Motoristas) :-
    findall((CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao),
            motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao),
            Motoristas).

recupera_motoristas_por_cpf(CPF, Motorista) :-
    motorista(CPF, Nome, Email, Senha, Telefone, CNH, CEP, Genero, Regiao),
    Motorista = motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao).

% Predicado para verificar se o banco de dados está vazio
banco_vazio :- 
    load_motorista_facts('../database/motoristas.csv'),
    \+ motorista(_, _, _, _, _, _, _, _, _).


% Predicado para escrever os motoristas em um arquivo CSV
escrever_motoristas_csv(Arquivo) :-
    open(Arquivo, write, Stream),
    (   motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao),
        format(Stream, '~w,~w,~w,~w,~w,~w,~w,~w,~w~n', [CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao]),
        fail % Continua procurando por mais motoristas
    ;   true % Encerra a busca quando não houver mais motoristas
    ),
    close(Stream).

