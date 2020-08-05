# Introduction

This is a Ruby project that models the business logic for a game.

I've encapsulated code that modifies the game state in command objects like `Game::AddPlayer`.
These command objects have a lot in common, and could be generalized as 'game actions'.

I've wrote unit and integration tests, mostly to make sure everything works as expected.

Reading the spec at `spec/integration/game_spec.rb` should be enough documentation about how this system works.

Thank you for reviewing!

# Setup

This project was developed using Ruby 2.7.0.

Install dependencies:

~~~bash
$ bundle install
~~~

Run tests:

~~~bash
$ bx rspec -f d
~~~
