:- dynamic motorista/9.

:-use_module('CsvModule.pl').

:- use_module("../Model/Motorista.pl").

% motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao)


% Predicados para cadastro de motorista
cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno) :-
    % Verificar se o CPF já está cadastrado
    load_motorista_facts('../Schemas/motoristas.csv'),
    ( motorista(CPF, _, _, _, _, _, _, _, _) ->
        write('CPF já cadastrado')
    ; % Se não estiver cadastrado, realizar o cadastro
        motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str),
        write_csv_row('motoristas.csv', [row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)]),
        assert_unique_motorista_fact(row(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao)),
        %assertz(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao))),
        Retorno = 'Cadastro realizado com sucesso'
    ).


% Predicado para remoção de motorista
remove_motorista(CPF) :-
    retract(motorista(CPF, _, _, _, _, _, _, _, _)).

% Predicado para atualização de motorista
atualiza_motorista(CPF, Campo, NovoValor) :-
    retract(motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao)),
    % Atualiza apenas o campo desejado
    (   Campo == 'cep' -> NovoCEP = NovoValor, assertz(motorista(CPF, NovoCEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao))
    ;   Campo == 'nome' -> NovoNome = NovoValor, assertz(motorista(CPF, CEP, NovoNome, Email, Telefone, Senha, CNH, Genero, Regiao))
    ;   Campo == 'email' -> NovoEmail = NovoValor, assertz(motorista(CPF, CEP, Nome, NovoEmail, Telefone, Senha, CNH, Genero, Regiao))
    ;   Campo == 'telefone' -> NovoTelefone = NovoValor, assertz(motorista(CPF, CEP, Nome, Email, NovoTelefone, Senha, CNH, Genero, Regiao))
    ;   Campo == 'senha' -> NovaSenha = NovoValor, assertz(motorista(CPF, CEP, Nome, Email, Telefone, NovaSenha, CNH, Genero, Regiao))
    ;   Campo == 'cnh' -> NovaCNH = NovoValor, assertz(motorista(CPF, CEP, Nome, Email, Telefone, Senha, NovaCNH, Genero, Regiao))
    ;   Campo == 'genero' -> NovoGenero = NovoValor, assertz(motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, NovoGenero, Regiao))
    ;   Campo == 'regiao' -> NovaRegiao = NovoValor, assertz(motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, NovaRegiao))
    ;   true % Se o campo não for nenhum dos especificados, mantém o motorista sem alteração
    ).

% Predicado para recuperar todos os motoristas de uma determinada região
recupera_motoristas_por_regiao(Regiao, Motoristas) :-
    findall((CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao),
            motorista(CPF, CEP, Nome, Email, Telefone, Senha, CNH, Genero, Regiao),
            Motoristas).

% Predicado para verificar se o banco de dados está vazio
banco_vazio :- 
    load_motorista_facts('../Schemas/motoristas.csv'),
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
