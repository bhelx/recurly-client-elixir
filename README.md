# Recurly [![Build Status](https://travis-ci.org/bhelx/recurly-client-elixir.svg?branch=master)](https://travis-ci.org/bhelx/recurly-client-elixir) [![Hex pm](https://img.shields.io/hexpm/v/recurly.svg?maxAge=2592000)](https://hex.pm/packages/recurly) [![API Docs](https://img.shields.io/badge/api-docs-blue.svg?style=flat)](https://hexdocs.pm/recurly/)

**Warning, this is alpha software and is not supported by Recurly. It should not be used in production yet
unless you really know what you are doing. There are bugs and the API will likely change**

Having said that, I would love help on making it production ready.

## Design

In writing this library from scratch, I'm trying to to test some "lessons learned" in maintaining the official
Recurly clients over the past year or so. I tried to take ideas from what I found worked and did not work in each library.
I've also taken some inspiration from other elixir projects [such as ecto](https://github.com/elixir-ecto/ecto).
Here are some of the design principles I've tried to follow that I think will help avoid some of the problems
I've encountered with the other libraries:

  1. `Use metaprogramming sparingly`. I've tried to only use metaprogramming for the internal APIs of the library.
      I wanted all public API functions to be greppable and documented.
  2. `Don't abstract away the underlying XML API`. The functions should be almost 1x1 with the HTTP calls.
      The use of `changesets` keeps the xml generation process transparent.
  3. `Don't allow "dirty" changes to resources`. If you want want to create or modify a resource,
      you may not modify the resource in memory. Instead, you must send a changeset to the server and get a new resource back.
      This eliminates the need to track changed attributes and use those changes to generate xml as well as make what you are
      sending to the server much more transparent. It also ensures that every resource you have is the exact represenation of
      what is on the server. This eliminates a whole class of annoying errors.

## Installation

  1. Add recurly to your list of dependencies in `mix.exs`:

      ```elixir
        def deps do
          [{:recurly, "~> 0.0.1"}]
        end
      ```

  2. Ensure recurly is started before your application:

      ```elixir
        def application do
          [applications: [:recurly]]
        end
      ```

