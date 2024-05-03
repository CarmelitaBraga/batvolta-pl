:- module(_,[]).

:- use_module('src/Controller/ControllerMotorista.pl').
:- use_module('src/Controller/CaronaController.pl').

motoristas_csv('database/motoristas.csv').
caronas_csv('database/caronas.csv').
viagens_csv('database/viagemPassageiros.csv').

join_carona_viagem_by_motorista(MotoristaCpf, Viagens):-
    mostrar_viagens_por_motorista(MotoristaCpf, CaronasMotorista),
    (CaronasMotorista \= [] ->
        findall(Viagem, (member(Carona, CaronasMotorista), get_viagens_by_carona(Carona, Viagem)), Viagens)
    ; Viagens = []
    ).

cpf_motorista(row(Cpf, _, _, _, _, _, _, _, _), Cpf).
avaliacao_motorista(row(_, _, _, _, _, _, _, _, _, Avaliacao), Avaliacao).

map_avaliacoes_motoristas(Motoristas, Result):-
    findall((MotoristaCpf, Avaliacao), 
            (member(Motorista, Motoristas), 
             cpf_motorista(Motorista, MotoristaCpf), 
             mostrar_viagens_por_motorista(MotoristaCpf, Caronas),
             member(Carona, Caronas),
             avaliacao_motorista(Carona, Avaliacao)), 
            Result).

% avaliacaoMotorista :: String -> IO Float
% avaliacaoMotorista idMotorista = do
%     viagensMotorista <- joinCaronaViagemByMotorista idMotorista
%     let viagensAvaliadas = filter (\a -> avaliacaoMtrst a /= 0) viagensMotorista
%         numViagens = fromIntegral $ length viagensAvaliadas
%         somatorioAvaliacoes = sum $ map avaliacaoMtrst viagensAvaliadas
%         mediaAvaliacao = if numViagens == 0 then fromIntegral 0 else fromIntegral somatorioAvaliacoes / numViagens
%     return mediaAvaliacao

% takeAvaliationsDecrescent :: Int -> [(String, Float)] -> IO [(String, Float)]
% takeAvaliationsDecrescent amostra avaliacoesEntidade = do
%     let sortedAvaliacoes = sortBy (comparing snd) avaliacoesEntidade
%         reversedAvaliacoes = reverse sortedAvaliacoes
%         topAvaliacoes = take amostra reversedAvaliacoes
%     return topAvaliacoes

% getTopMotoristasByRegiao :: String -> IO [String]
% getTopMotoristasByRegiao regiao = do
%     motoristasRegiao <- getAllMotoristasByRegiao regiao
%     motoristasAvaliacoes <- mapAvaliacoesMotoristas motoristasRegiao
%     topMotoristasRegiao <- takeAvaliationsDecrescent 3 motoristasAvaliacoes
%     mapM tupleToString topMotoristasRegiao

% recuperarMotoristasPorRegiao(Regiao, Motoristas)

% getMelhoresMotoristas :: IO [String]
% getMelhoresMotoristas = do 
%     motoristas <- carregarMotoristas "./database/motorista.csv"
%     avaliacoes <- mapAvaliacoesMotoristas motoristas
%     melhores <- takeAvaliationsDecrescent 5 avaliacoes
%     mapM tupleToString melhores

% tupleToString :: (String, Float) -> IO String
% tupleToString (cpf, avaliacao) = do
%     name <- cpfToName cpf
%     return $ name ++ ": " ++ show avaliacao