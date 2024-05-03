:- module(_, [
    cadastrar_passageiro_logic/8,
    remove_passageiro_logic/3,
    atualiza_cadastro_logic/5,
    visualiza_info_logic/2,
    login_passageiro_logic/3,
    recupera_notificacao_logic/2,
    cadastra_notificacao/5
]).

:- use_module('../Util/Utils.pl').
:- use_module('../Schemas/SchemaPassageiro.pl').
:- use_module('../Schemas/NotificacaoPassageiro.pl').


cadastrar_passageiro_logic(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno):-
    (   \+ validar_cpf(CPF) 
        ->  write('CPF não atende aos requisitos\n')
    ; 
        null_or_empty(Nome) 
        ->  write('Nome não pode ser vazio\n')
    ;
        \+ validar_genero(Genero) 
        ->  write('Genero deve ser M, F ou NB.\n')
    ;
        \+ validar_email(Email) 
        ->  write('Email não atende aos requisitos\n')
    ;
        null_or_empty(Telefone) 
        ->  write('Telefone não pode ser vazio\n')
    ;
        null_or_empty(CEP) 
        ->  write('CEP não pode ser vazio\n')
    ;
        null_or_empty(Senha) 
        ->  write('Senha não pode ser vazia\n')
    ;
        cadastra_passageiro(Nome, CPF, Genero, Email, Telefone, CEP, Senha, Retorno)
    ).


remove_passageiro_logic(CPF, Senha, Retorno):-
    (   get_passageiro_by_cpf(CPF, Passageiro),
        last(Passageiro, SenhaPassageiro),
        (   confere_senha(SenhaPassageiro,Senha)
        ->  (   remove_passageiro(CPF, Resposta),
                Retorno = Resposta
            )
        ;   
            Retorno = 'Senha incorreta.'
        )
    ).

% remove_passageiro_logic(12345678901,121210164, Retorno)

atualiza_cadastro_logic(CPF, SenhaPassada, Coluna, NovoValor, Retorno):-
    (   null_or_empty(NovoValor)
        -> write('O novo valor nao pode ser vazio\n')
    ;
        get_passageiro_by_cpf(CPF, Passageiro),
        last(Passageiro, Senha),
        (   confere_senha(Senha, SenhaPassada)
            ->  (   atualiza_passageiro(CPF, Coluna, NovoValor, Resposta),
                    Retorno = Resposta
                )
        ;   
            write('Senha incorreta.\n')
        )
    ).

visualiza_info_logic(CPF, PassageiroStr):- 
    get_passageiro_by_cpf(CPF, Passageiro),
    passageiro_to_string(Passageiro, Retorno),
    PassageiroStr = Retorno.
    
login_passageiro_logic(Email, Senha, Retorno):-
    (get_passageiro_by_email(Email, Passageiro)
        ->  last(Passageiro,SenhaPassageiro),
            (   confere_senha(SenhaPassageiro, Senha)
                ->  Retorno = Passageiro
            ;
                write('Senha incorreta\n'),
                false
            )
    ).

recupera_notificacao_logic(CPF,Retorno):-
    recupera_notificacao_passageiro(CPF, Lista),
    (Lista == 'Passageiro nao tem nenhuma notificacaoo.' ->
        Retorno = Lista
    ;    
        list_to_string(Lista,'',Retorno)
    ).

cadastra_notificacao(Passageiro, Motorista, Carona, Conteudo, Resposta):-
    cadastrar_notificacao(Passageiro, Motorista, Carona, Conteudo, Resposta).