:- module(_, []).

:- use_module('src/Logic/DashboardLogic.pl').

buscar_melhores_motoristas(MelhoresMotoristas):-
    get_top_motoristas(MelhoresMotoristas).

buscar_melhores_motoristas_regiao(Regiao, MelhoresMotoristas):-
    get_top_motoristas_by_regiao(Regiao, MelhoresMotoristas).

buscar_destinos_mais_frequentes(Destinos):-
    top_5_destinos(Destinos).