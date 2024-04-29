:- module(_, 
    [info_trecho_by_carona_passageiro/3%,
    % cancelar_viagem_passageiro/3,
    % get_viagens_passageiro_sem_avaliacao/2
    ]).

:- use_module('src/Schemas/CsvModule.pl').

csv_file('database/viagemPassageiros.csv').
viagem_pass_column(1).
carona_column(2).
aceito_column(3).
rota_column(4).
avaliacao_column(5).
passageiro_column(6).

% Recebe um átomo
info_trecho_by_carona_passageiro(IdCarona, PassageiroCpf, Resp):- 
    csv_file(File),
    carona_column(Carona_Column),
    read_csv_row(File, Carona_Column, IdCarona, Viagens),
    (member(row(_, IdCarona, _, _, _, PassageiroCpf), Viagens) ->
        Resp = Viagens
    ;
        Resp = 'Nenhum trecho correspondente a passageiro encontrado!'
    ).
% info_trecho_by_carona_passageiro(7,09876543210, T).
% info_trecho_by_carona_passageiro(8,09876543210, T).

% cancelar_carona_passageiro/2,
% cancelaViagemPassageiro :: Int -> String -> IO String
% cancelaViagemPassageiro idCarona idPassageiro = do
%     maybeViagem <- getViagemByCaronaPassageiro idCarona idPassageiro
%     case maybeViagem of
%         [] -> return "Trecho de carona inexistente para o passageiro informado!"
%         [viagem] -> do
%             let viagemId = pid viagem
%             if aceita viagem then
%                 return "O passageiro ja foi aceito, não podera mais cancelar."
%             else do
%                 deleteViagemById viagemId
%                 return "Carona cancelada com sucesso!"

% mostrar_viagem_passageiro/2,
% get_viagem_sem_avaliacao/2,
% avaliar_motorista/4
% criarViagemPassageiro