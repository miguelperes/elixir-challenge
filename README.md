# Elixir Challenge [![Build Status](https://travis-ci.org/miguelperes/elixir-challenge.svg?branch=master)](https://travis-ci.org/miguelperes/elixir-challenge) [![Coverage Status](https://coveralls.io/repos/github/miguelperes/elixir-challenge/badge.svg?branch=master)](https://coveralls.io/github/miguelperes/elixir-challenge?branch=master)
Elixir project made for the [Stone Tech Challenge](https://github.com/stone-payments/tech-challenge)

## About

The idea of the project is to create a set of tools to handle monetary operations, such as transfering money between accounts and currency conversion.

## Usage

### Installing
Run `mix deps.get` to install dependencies
Run `iex -S mix` to start Elixir's interactive shell

### Testing / Quality
`mix format` to format the code ensuring proper style
`mix test` to run unit tests
`mix coveralls` to check test coverage
`MIX_ENV=test mix coveralls.detail` to show code coverage details

## Documentation
`mix docs` to generate update documentations (as an HTML file)

## Code Quality

#### Elixir Formatter
The [Elixir Formatter](https://elixir-lang.org/blog/2018/01/17/elixir-v1-6-0-released/) (v1.6+) is being used to ensure the code is compliant with the language style guide.

#### Credo

#### ExCoveralls

#### Travis CI

