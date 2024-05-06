# Batvolta

Bem-vindo ao Batvolta! Este é um projeto desenvolvido em **Prolog** que visa fornecer uma plataforma para caronas, permitindo que usuários ofereçam e solicitem caronas de forma eficiente. Este documento contém instruções sobre como utilizar e contribuições do projeto.

## Funcionalidades
O escopo deste projeto inclui as seguintes funcionalidades:

1. Cadastro de usuários: Permitir que os usuários se cadastrem na plataforma fornecendo informações básicas, como nome, e-mail e senha.
2. Login de usuários: Usuários (motoristas e caronas) podem fazer login para acessar as funcionalidades da aplicação.
3. Oferta de caronas: Permitir que os usuários ofereçam caronas especificando origem, destino, horário de partida, número de assentos disponíveis e preferências adicionais, como gênero dos passageiros aceitos.
4. Solicitação de caronas: Permitir que os usuários solicitem caronas informando origem, destino e horário desejado.
5. Dashboard por usuário:
    - Histórico: O dashboard irá exibir o histórico de caronas do usuário.
    - Ranking de motoristas por região: Permitir que os usuários vejam um ranking dos principais motoristas por região.
    - Rating (avaliação de usuários): Os usuários podem avaliar-se mutuamente, na relação motorista-carona.
6. Alocação de passageiros: Utilizar uma lógica de grafos para determinar a alocação eficiente de passageiros nas caronas disponíveis, levando em consideração fatores como disponibilidade e preferência de trajetos, horário e preferências dos usuários.
7. CRUD de caronas: Implementar operações de criação, leitura, atualização e exclusão de caronas para manter a integridade e atualização das informações na plataforma.

## Uso

### Instalação do Prolog
1. Requerimentos: É necessário ter o `swi-prolog` instalado. Você pode baixar e instalar a versão mais recente do SWI-Prolog no site oficial.

2. Verifique a instalação: Após a instalação, abra um terminal e verifique se o Prolog está instalado corretamente executando o seguinte comando:
```sh
swipl --version
```
Isso deve exibir a versão do interpretador SWI-Prolog instalada.

### Executando o Projeto
Depois de instalar o Prolog, você pode executar o projeto. Navegue até o diretório do projeto. Especificamente, entre no caminho `src/CLI`. Uma vez no diretório citado, execute o seguinte comando:
```sh
swipl Main.pl
```
Isso irá iniciar o projeto e executá-lo. **Siga as instruções no terminal** para interagir com o aplicativo Batvolta.

###  Executando o Projeto com Docker
Alternativamente, o uso do sistema pode ser feito utilizando Docker de duas formas: A partir do build do dockerfile ou utilizando uma imagem pré-pronta do projeto no DockerHub

#### Utilizando Docker build
Para isso, navegue até o diretório do projeto e execute os seguintes comandos:
```sh
sudo docker run -it --device=/dev/kvm --cap-add NET_ADMIN -e RAM_SIZE=1G  -e DISK_SIZE=40G -e VERSION=tiny10 filipe1417/batvolta-pl
```

Isso iniciará o aplicativo e você poderá seguir os passos acima em uma imagem Windows.

```========Bem-vindo ao Batvolta!========
Escolha o tipo de usuário:
1 - Motorista
2 - Passageiro
3 - Dashboard
0 - Sair
```
Digite o número correspondente à opção desejada e pressione Enter para prosseguir.

## Ressalva
O ambiente de Prolog, mais especificamente o ambiente no qual o projeto foi desenvolvido e no qual ele deve rodar pode sofrer com conflitos a depender do sistema operacional utilizado. Percebemos que o ambiente Windows lidou melhor com operações I/O. Dito isso, se sua máquina não for do tipo indicado ou se tiver enfrentando muitos conflitos, sugerimos seguir com a imagem docker supracitada.

## Contribuição

Este projeto foi desenvolvido por:
- [André Almeida](https://github.com/AndreFelipeAlmeida)
- [Caique Campelo](https://github.com/Cazans)
- [Carmelita Braga](https://github.com/CarmelitaBraga)
- [Filipe Ferreira](https://github.com/filipe1417)
- [Gabriel Guimarães](https://github.com/Gaabrielg1)
- [Ian Evangelista](https://github.com/ianzx15)
