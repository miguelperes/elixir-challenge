# Elixir Challenge [![Build Status](https://travis-ci.org/miguelperes/elixir-challenge.svg?branch=master)](https://travis-ci.org/miguelperes/elixir-challenge) [![Coverage Status](https://coveralls.io/repos/github/miguelperes/elixir-challenge/badge.svg?branch=master)](https://coveralls.io/github/miguelperes/elixir-challenge?branch=master)
Elixir project made for the [Stone Tech Challenge](https://github.com/stone-payments/tech-challenge)

## About

The idea of the project is to create a set of tools to handle monetary operations, such as transfering money between accounts and currency conversion.

It uses the [Money](https://hexdocs.pm/ex_money/readme.html) package in conjunction with [Decimal](https://hexdocs.pm/decimal/) to avoid floating point rounding issues: a Money struct is compose of a Decimal and an atom (for the currency code). All  arithmetic operations in [`FinancialSystem`](http://elixir-stone-challenge-doc.surge.sh/FinancialSystem) are wrapped using Decimal arithmetic, ensuring the correct result.

## Usage

### Installing
`mix deps.get` to install dependencies  
`iex -S mix` to start Elixir's interactive shell

### Testing / Quality
`mix test` to run unit tests  
`mix coveralls` to check test coverage  
`MIX_ENV=test mix coveralls.detail` to show code coverage details  
`mix format` to format the code ensuring proper style (`.formatter.exs` rules)  
`mix credo` to run credo

## Documentation
[Access online documentation here](http://elixir-stone-challenge-doc.surge.sh/)  
`mix docs` to generate up to date documentation (at `doc/index.html`)

## Code Quality
Tools used to ensure code quality and proper style:

- The [Elixir Formatter](https://elixir-lang.org/blog/2018/01/17/elixir-v1-6-0-released/) (v1.6+) is being used to ensure the code is compliant with the language style guide.
- [Credo](https://github.com/rrrene/credo) is a static code analysis tool that is being used to ensure code quality (checking for refactor opportunities, warning about commom mistakes, duplicated code, etc), when it doesn't go against the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)
- [ExCoveralls](https://github.com/parroty/excoveralls) is a coverage report tool with coveralls.io integration
- [Travis CI](https://travis-ci.org/miguelperes/elixir-challenge/) is being used for Continuous Integration, executing tests and sending a report to [coveralls.io](https://coveralls.io/github/miguelperes/elixir-challenge) each time a branch is pushed. The `master` branch is protected, which means that only branches that passes Travis checks will be able to merged to it.

