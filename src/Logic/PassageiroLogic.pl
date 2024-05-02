
module(_, [
    cadastro_passageiro_logic/8,
    remove_passageiro_logic/3,
    atualiza_cadastro_logic/5,
    visualiza_info_logic/0,
    login_passageiro_logic/3,
    carregar_notificacoes_logic/0
]).

:- use_module('../Util/Utils.pl').
:- use_module('../Schemas/SchemaPassageiro.pl').

cadastrar_passageiro_logic(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno):-
    (   \+ validar_cpf(CPF) 
        ->  write('CPF não atende aos requisitos')
    ; 
        null_or_empty(Nome) 
        ->  write('Nome não pode ser vazio')
    ;
        \+ validar_genero(Genero) 
        ->  write('Genero deve ser M ou F')
    ;
        \+ validar_email(Email) 
        ->  write('Email não atende aos requisitos')
    ;
        null_or_empty(Telefone) 
        ->  write('Telefone não pode ser vazio')
    ;
        null_or_empty(CEP) 
        ->  write('CEP não pode ser vazio')
    ;
        null_or_empty(Senha) 
        ->  write('Senha não pode ser vazia')
    ;
        cadastra_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Resp),
        Retorno = Resp
    ).


remove_passageiro_logic(CPF, Senha, Retorno):-
    (   \+ validar_cpf(CPF) 
        ->  Retorno = 'CPF não atende aos requisitos'
    ;
        get_passageiro_by_cpf(CPF, Passageiro),
        last(Passageiro, SenhaPassageiro),
        (   confere_senha(SenhaPassageiro,Senha)
        ->  (   remove_passageiro(CPF, Retorno),
                Retorno = 'Passageiro removido com sucesso'
            )
        ;   
            Retorno = 'Senha incorreta'
        )
    ).

% remove_passageiro_logic(12345678901,121210164, Retorno):-

atualiza_cadastro_logic(CPF, SenhaPassada, Coluna, NovoValor, Retorno):-
    (   null_or_empty(NovoValor)
        -> write('O novo valor nao pode ser vazio'),
            Retorno = ' '
    ;
        get_passageiro_by_cpf(CPF, Passageiro),
        last(Passageiro, Senha),
        (   confere_senha(Senha, SenhaPassada)
            ->  (   atualiza_passageiro(CPF, Coluna, NovoValor, Resposta),
                    Retorno = Resposta
                )
        ;   
            write('Senha incorreta'),
            Retorno = ' '
        )
    ).

visualiza_info_logic():- 
    write("Logic do visualiza").

login_passageiro_logic(Email, Senha, Retorno):-
    (   \+ validar_email(Email) 
        ->  write('Email não atende aos requisitos'),
            Retorno = " "
    ;
        (   existe_passageiro_by_email(Email)
            ->  get_passageiro_by_email(Email, Passageiro),
                last(Passageiro,SenhaPassageiro),
                (   confere_senha(SenhaPassageiro, Senha)
                    ->  Retorno = Passageiro
                ;
                    write('Senha incorreta'),
                    Retorno = " "
                )
            ;   
                write('Passageiro não encontrado')
        )
        ;
        write("Passageiro não encontrado"),
        Retorno = " "
    ).

carregar_notificacoes_logic():-
    write("Logic do carrega").