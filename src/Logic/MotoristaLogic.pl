:- module(_, [
        cadastra_Logic/10,
        atualiza_Logic/5,
        remove_Logic/3,
        recupera_cpf_logic/2,
        recupera_notificacao_logic/2
]).

:- use_module("../Schemas/MotoristaSchema.pl").
:- use_module("../Util/Util.pl").
:- use_module("../Schemas/NotificacaoM.pl").

cadastra_Logic(CPF, Nome, Email, Telefone, Senha, CNH, CEP, Genero, Regiao, Retorno):-
( validarCPF(CPF) ->
    (nullOrEmpty(Nome) ->
        Retorno = 'Nome não pode ser vazio.'
    ;
        (validarEmail(Email) ->
            (nullOrEmpty(Telefone) ->
                Retorno = 'Telefone nao pode ser vazio.'
            ;
                (valida_senha(Senha) ->
                
                    (nullOrEmpty(CEP) ->
                        Retorno = 'CEP nao pode ser vazio.'
                        ;
                        (nullOrEmpty(CNH) ->
                            Retorno = 'CNH nao pode ser vazio.'
                        ;
                            (validarGenero(Genero) ->
                                Retorno = 'Digite um genero valido. Exemplo: M, F, NB.'
                            ;
                                (validaRegiao(Regiao) ->
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

recupera_regiao_logic(Regiao,Retorno):-
    recupera_motoristas_por_regiao(Regiao, MotoristasStr),
    list_to_string(MotoristasStr,'',Retorno).

recupera_notificacao_logic(CPF,Retorno):-
    recupera_notificacao_motoristas(CPF, Lista),
    list_to_string(Lista,'',Retorno).
