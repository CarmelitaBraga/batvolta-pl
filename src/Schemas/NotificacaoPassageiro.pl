:- module(_,[
   cadastrar_notificacao/5,
   recupera_notificacao_passageiro/2
]).

file('../../database/notificacaoPassageiro.csv').

:- use_module('CsvModule.pl').

:- dynamic id/1.

% Fato estático para inicializar o ID ao carregar o módulo
:- initialization(loadId).

loadId :-
    file(File),
    getAllRows(File, Rows),
    
    (Rows = [] ->
    assertz(id(0))
    ;
    encontrar_maior_id(Rows, 0, Id),
    NovoId is Id + 1,
    assertz(id(NovoId))
    ).

encontrar_maior_id([], MaiorId, MaiorId).
encontrar_maior_id([row(Id, _, _, _, _)|Rest], MaiorId, R) :-
    MaiorId < Id,
    encontrar_maior_id(Rest, Id, R).
encontrar_maior_id([_|Rest], MaiorId, R) :-
    encontrar_maior_id(Rest, MaiorId, R).

incrementa_id :- retract(id(X)), Y is X + 1, assertz(id(Y)).


% Predicado para cadastrar notificação após obter o último ID
cadastrar_notificacao(Passageiro, Motorista, Carona, Conteudo, Resposta) :-
    file(Caminho),
    id(ID),
    write_csv_row(Caminho, [row(ID, Passageiro, Motorista, Carona, Conteudo)]),
    incrementa_id,
    Resposta = 'Notificacao criada com sucesso.'.


notificacaoToStr(notificacao(id(ID),motorista(Motorista),passageiro(_),carona(Carona),conteudo(Conteudo), Str)) :-
    atomic_list_concat(['Notificacao', ID , ': Ola o Motorista' , Motorista , Conteudo , 'na carona de id:', Carona], ' ', Str).

converteToStr(row(ID, Motorista, Passageiro, Carona, Conteudo), Str) :-
    notificacaoToStr(notificacao(id(ID),motorista(Motorista),passageiro(Passageiro),carona(Carona),conteudo(Conteudo), Str)).

recupera_notificacao_passageiro(Passageiro, NotificacaoStr) :-
    file(Caminho),
    atom_number(Passageiro, Number),
    read_csv_row(Caminho, 2, Number, Rows),
    (Rows == [] -> 
        NotificacaoStr = 'Passageiro nao tem nenhuma notificacaoo.'
    ;
        maplist(converteToStr, Rows, Notificacao),
        reverse(Notificacao, NotificacaoStr)
    ).