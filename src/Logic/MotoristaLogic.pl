:- module(_, [
        cadastra_Logic/10,
        atualiza_Logic/5,
        remove_Logic/3,
        recupera_cpf_logic/2,
        recupera_notificacao_logic/2,
        realiza_login_logic/3,
        cadastra_notificacao/5
]).

:- use_module('../Schemas/MotoristaSchema.pl').
:- use_module('../Util/Utils.pl').
:- use_module('../Schemas/NotificacaoMotorista.pl').

cadastra_Logic(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno):-
( validar_cpf(CPF) ->
    (null_or_empty(Nome) ->
        Retorno = 'Nome não pode ser vazio.'
    ;
        (validar_email(Email) ->
            (null_or_empty(Telefone) ->
                Retorno = 'Telefone nao pode ser vazio.'
            ;
                (validar_senha(Senha) ->
                
                    (null_or_empty(CEP) ->
                        Retorno = 'CEP nao pode ser vazio.'
                        ;
                        (null_or_empty(CNH) ->
                            Retorno = 'CNH nao pode ser vazio.'
                        ;
                            (validar_genero(Genero) ->
                                Retorno = 'Digite um genero valido. Exemplo: M, F, NB.'
                            ;
                                (validar_regiao(Regiao) ->
                                    Retorno = 'Digite uma regiao valida. Exemplo: norte, nordeste, centro-oeste, sudeste, sul'
                                ;
                                    downcase_atom(Genero, G),
                                    downcase_atom(Regiao, R),
                                    atom_number(CNH, C),
                                    cadastra_motorista(CPF, Nome, Email, Telefone, Senha, C, CEP, G, R, Resposta),
                                    Retorno = Resposta
                                )
                            )
                        )
                    )
                
                ;
                
                    Retorno = 'Senha deve ser no minimo tamanho 4, e conter pelo menos uma letra.'
                )
            )
        ;
            Retorno = 'Insira um Email valido.'
        )
    )
;
    Retorno = 'CPF não pode ser Null'
).


atualiza_Logic(CPF, Senha, Campo, NovoValor, Retorno):-
    (Campo == 'senha' ->
        (validar_senha(NovoValor) ->
            (confere_senha(CPF, Senha) ->
            atualiza_motorista(CPF,Campo,NovoValor,Resposta),
            Retorno = Resposta
            ;
            Retorno = 'Senha incorreta, tente novamente.'
            )
        ;
            Retorno = 'Senha deve ser no minimo tamanho 4, e conter pelo menos uma letra.'
        )
    ;
        (null_or_empty(NovoValor) ->
            Retorno = 'Novo valor nao pode ser vazio.'
        ;
            (confere_senha(CPF, Senha) ->
                atualiza_motorista(CPF,Campo,NovoValor,Resposta),
                Retorno = Resposta
            ;
                Retorno = 'Senha incorreta, tente novamente.'
            )
        )
    ).

remove_Logic(CPF,Senha,Retorno):-
    (confere_senha(CPF, Senha) ->
        remove_motorista(CPF,Resposta),
        Retorno = Resposta
    ;
        Retorno = "Senha incorreta, tente novamente."
    ).

recupera_cpf_logic(CPF,Retorno):-
    recupera_motoristas_por_cpf(CPF, Resposta),
    Retorno = Resposta.

recupera_notificacao_logic(CPF,Retorno):-
    recupera_notificacao_motoristas(CPF, Lista),
    (Lista == 'Sem novas mensagens para motorista.' ->
        Retorno = Lista
    ;    
        list_to_string(Lista,'',Retorno)
    ).

realiza_login_logic(Email,Senha,Retorno):-
    (confere_senha_login(Email, Senha) ->
        recupera_motoristas_por_email(Email,Motorista),
        convert_list_atom(Motorista,Retorno)
    ;
    Retorno = 'Login incorreto.'
    ).

cadastra_notificacao(Motorista, Passageiro, Carona, Conteudo, Resposta):-
    cadastrar_notificacao(Motorista, Passageiro, Carona, Conteudo, Resposta).