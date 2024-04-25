:- use_module(library(csv)).

% Facts
statusCarona(naoIniciada).
statusCarona(emAndamento).
statusCarona(finalizada).

% Function to convert a Carona to a String
caronaToStr(Carona, Str) :-
    Carona = carona(cid(Cid), 
                    hora(Hora), 
                    date(Date), 
                    destinos(Destinos), 
                    motorista(Motorista), 
                    passageiros(Passageiros), 
                    valor(Valor), 
                    status(Status), 
                    numPassageirosMaximos(NumPassageirosMaximos), 
                    avaliacaoPassageiros(AvaliacaoPassageiros)),
    atomics_to_string([Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros], ",", Str).

assert_carona_fact(row(Cid, Hora, Date, Destinos, Motorista, Passageiros, Valor, Status, NumPassageirosMaximos, AvaliacaoPassageiros)) :-
    assertz(carona(cid(Cid), hora(Hora), date(Date), destinos(Destinos), motorista(Motorista), passageiros(Passageiros), valor(Valor), status(Status), numPassageirosMaximos(NumPassageirosMaximos), avaliacaoPassageiros(AvaliacaoPassageiros))).

load_carona_facts(File) :-
    csv_read_file(File, Rows, []),
    maplist(assert_carona_fact, Rows).
