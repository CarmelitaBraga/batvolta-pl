module(_, [
    cadastro_passageiro_logic/8,
    remove_passageiro_logic/3,
    atualiza_cadastro_logic/0,
    visualiza_info_logic/0,
    login_passageiro_logic/3,
    carregar_notificacoes_logic/0
]).

:- use_module('../Util/Utils.pl').
:- use_module('../Schemas/SchemaPassageiro.pl').

cadastrar_passageiro_logic(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno):-
    (   \+ validar_cpf(CPF) 
        ->  write('CPF não atende aos requisitos'), 
            Retorno = " "
    ; 
        null_or_empty(Nome) 
        ->  write('Nome não pode ser vazio'), 
            Retorno = " "
    ;
        \+ validar_genero(Genero) 
        ->  write('Genero deve ser M ou F'),
            Retorno = " "
    ;
        \+ validar_email(Email) 
        ->  write('Email não atende aos requisitos'),
            Retorno = " "
    ;
        null_or_empty(Telefone) 
        ->  write('Telefone não pode ser vazio'),
            Retorno = " "
    ;
        null_or_empty(CEP) 
        ->  write('CEP não pode ser vazio'),
            Retorno = " "
    ;
        null_or_empty(Senha) 
        ->  write('Senha não pode ser vazia'),
            Retorno = " "
    ;
        cadastra_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno),
        Retorno = " "
    ).


remove_passageiro_logic(CPF, Senha, Retorno):-
    ( validar_cpf(CPF) ->  Retorno = 'CPF não atende aos requisitos'
    ;   get_passageiro_by_cpf(CPF, Retorno),
        (   confere_senha(CPF,Senha)
        ->  (   remove_passageiro(CPF, Retorno),
                Retorno = 'Passageiro removido com sucesso'
            )
        ;   Retorno = 'Senha incorreta'
        )
    ;   Retorno = 'Passageiro não encontrado'
    ).

atualiza_cadastro_logic():-
    write("Logic do atualiza").

visualiza_info_logic():- 
    write("Logic do visualiza").

login_passageiro_logic(Email, Senha, Retorno):-
    (   existe_passageiro_by_email(Email),
        confere_senha(Senha)
        ->  Retorno = get_passageiro_by_email(Email)
    ;
        confere_senha(Senha)
        ->  write("Senha incorreta"),
            Retorno = " "
    ; 
        validar_email(Email)
        ->  write("Email incorreto"),
            Retorno = " "
    ).

carregar_notificacoes_logic():-
    write("Logic do carrega").