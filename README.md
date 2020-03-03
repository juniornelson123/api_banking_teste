
# API BANKING

Repositório para apresentar solução ao teste proposta pelo # **[desafio-backend-stone](https://gist.github.com/thulio/e021378b27ff471795e37ba5a5b73539)** da stone pagamentos. Utilizando Elixir para o desenvolvimento da plataforma.

## [](https://github.com/juniornelson123/api_banking_teste/blob/master/readme/README_pt.md#o-projeto)O projeto:

### [](https://github.com/juniornelson123/api_banking_teste/blob/master/readme/README_pt.md#plataforma)Plataforma

A API foi desenvolvida utilizando Elixir + Phoenix Framework, possibilitando o cadastro de novos usuarios e contas, além de transações(saque e transferencias).

## [](https://github.com/juniornelson123/api_banking_teste/blob/master/readme/README_pt.md#depend%C3%AAncias)Dependências

	Elixir >= 1.9.4
	Phoenix Framework >= 1.4
	PostgreSQL >= 9.0

	Instalação Elixir: https://elixir-lang.org/install.html
	Instalação Phoenix Framework: https://hexdocs.pm/phoenix/installation.html
	
-   [EctoSql](https://github.com/elixir-ecto/ecto_sql)  - SQL-based adapters for Ecto and database migrations.
-   [Postgrex](https://github.com/elixir-ecto/postgrex)  - PostgreSQL driver for Elixir.
-   [Poison](https://github.com/devinus/poison)  - An incredibly fast, pure Elixir JSON library.
-   [Phoenix](https://github.com/phoenixframework/phoenix)  - A productive web framework that does not compromise speed or maintainability.
-   [Guardian](https://github.com/ueberauth/guardian) - Guardian is a token based authentication library for use with Elixir applications.
-   [Argon2](https://github.com/riverrun/argon2_elixir) - Argon2 password hashing library for Elixir.
-   [Poison](https://github.com/devinus/poison)  - An incredibly fast, pure Elixir JSON library.
-   [Faker](https://github.com/elixirs/faker)  - Faker is a pure Elixir library for generating fake data.
-   [Elixir JSON Schema validator](https://github.com/jonasschmidt/ex_json_schema)  - An Elixir JSON Schema validator
-   [PhoenixSwagger](https://github.com/xerions/phoenix_swagger)  - Is the library that provides swagger integration to the phoenix web framework.

## [](https://github.com/juniornelson123/api_banking_teste/blob/master/readme/README_pt.md#como-come%C3%A7ar)Como Começar

### Atualizar Dependências

```docker-compose run --rm api mix deps.get ```
ou 
```./mix deps.get```

### Criar Banco de Dados

```docker-compose run --rm api mix ecto.create``` 
  ou 
```./mix ecto.create```

### Migrações Banco de Dados

```docker-compose run --rm api mix ecto.migrate``` 
  ou 
```./mix ecto.migrate```

### Semear Banco de Dados

```docker-compose run --rm api mix seed``` 
  ou 
```./mix seed```

### Iniciar Servidor

```docker-compose up```

Disponível: http://localhost:4000/api/documentation

### Gerar Documentação

```docker-compose run --rm api mix swagger``` 
  ou 
```./mix swagger```

Disponível: http://localhost:4000/api/documentation

### Testes

```docker-compose run --rm api mix test```


### Shell

```docker-compose run --rm api iex -S mix```


### [](https://github.com/juniornelson123/blob/master/readme/README_pt.md#lan%C3%A7amentos-principais)Lançamentos Principais

- Cadastro e gerenciamento de Contas
- Transferências entre contas

Disponível: https://advanced-boiling-butterfly.gigalixirapp.com/api/documentation

## Documentação

https://advanced-boiling-butterfly.gigalixirapp.com/api/documentation

## Usuarios para teste

username: user1 
name: user1
password: user1@banking

username: user2 
name: user2
password: user2@banking

username: admin 
name: admin
password: admin@banking

## License

[![License](https://camo.githubusercontent.com/107590fac8cbd65071396bb4d04040f76cde5bde/687474703a2f2f696d672e736869656c64732e696f2f3a6c6963656e73652d6d69742d626c75652e7376673f7374796c653d666c61742d737175617265)](http://badges.mit-license.org/)

-   **[MIT license](http://opensource.org/licenses/mit-license.php)**
-   Copyright 2020 ©  [Nelson junior](http://github.com/juniornelson123).
