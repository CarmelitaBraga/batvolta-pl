:- module(Motorista,[
    motoristaToStr/2,
    possui_motorista/2
]).

:- use_module(library(csv)).

% Function to convert a Motorista to a String
motoristaToStr(motorista(cpf(CPF), nome(Nome), email(Email), senha(Senha), telefone(Telefone), cnh(CNH), cep(CEP), genero(Genero), regiao(Regiao)), Str) :-
    atomic_list_concat(['Motorista:', 'Cpf =', CPF, ',', 'Nome =', Nome, ',', 'Email =', Email, ',', 'Senha =', Senha, ',', 'Telefone =', Telefone, ',', 'CNH =', CNH, ',', 'CEP =', CEP, ',', 'Genero =', Genero, ',', 'Regiao =', Regiao], ' ', Str).
