:- use_module("../Schemas/MotoristaSchema.pl").
:- use_module("../Util/Util.pl").

cadastra_Logic(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno):-
( validarCPF(CPF) ->
    (nullOrEmpty(Nome) ->
        Retorno = 'Nome não pode ser vazio.'
    ;
        (validarEmail(Email) ->
            (nullOrEmpty(Telefone) ->
                Retorno = 'Telefone não pode ser vazio.'
            ;
                (nullOrEmpty(Senha) ->
                    Retorno = 'Senha não pode ser vazio.'
                ;
                    (nullOrEmpty(CEP) ->
                        Retorno = 'CEP não pode ser vazio.'
                    ;
                        (nullOrEmpty(CNH) ->
                            Retorno = 'CNH não pode ser vazio.'
                        ;
                            (validarGenero(Genero) ->
                                Retorno = 'Digite um genero valido. Exemplo: M, F, NB.'
                            ;
                                (validarRegiao(Regiao) ->
                                    Retorno = 'Digite uma regiao valida. Exemplo: norte, nordeste, centro-oeste, sudeste, sul'
                                ;
                                    cadastra_motorista(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Resposta),
                                    Retorno = Resposta
                                )
                            )
                        )
                    )
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
        (confere_senha(CPF, Senha) ->
            atualiza_motorista(CPF,Campo,NovoValor,Resposta),
            Retorno = Resposta
        ;
            Retorno = "Senha incorreta, tente novamente."
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