:- module(Motorista,[
    motoristaToStr/2,
    possui_motorista/2
]).

:- use_module(library(csv)).

% Function to convert a Motorista to a String
motoristaToStr(Motorista, Str) :-
    Motorista = motorista(cpf(CPF), 
                    nome(Nome), 
                    email(Email), 
                    senha(Senha),
                    telefone(Telefone), 
                    cnh(CNH),
                    cep(CEP),  
                    genero(Genero), 
                    regiao(Regiao)
                ),
    atomics_to_string([CPF, Nome, Email, Senha, Telefone, CNH, CEP, Genero, Regiao], ",", Str).
    

possui_motorista(CPF, Retorno):-
    read_csv_row_by_list_element('database/motoristas.csv', 0, Rows),
    member(row(_, _, _, Trajeto, _, _, _, _, _, _), Rows),
    split_string(Trajeto, ";", "", ListaTrajeto),
    ordered_pair_in_list([Origem, Destino], ListaTrajeto).