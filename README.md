[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zabirauf/elixir_wit/master/LICENSE.md) [![Build Status](https://travis-ci.org/zabirauf/elixir_wit.svg?branch=master)](https://travis-ci.org/zabirauf/elixir_wit) [![Inline docs](http://inch-ci.org/github/zabirauf/elixir_wit.svg?branch=master)](http://inch-ci.org/github/zabirauf/elixir_wit) <a href="http://github.com/syl20bnr/spacemacs"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" alt="Made with Spacemacs"></a>

# Wit
Elixir client for the Wit API. Wit is the natural language engine for creating Bots.

## Documentation

API documentation is available at [https://hexdocs.pm/elixir_wit](https://hexdocs.pm/elixir_wit)

## Installation

The package can be installed as:

  1. Add elixir_wit to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:elixir_wit, "~> 1.0.0"}]
  end
  ```

## Usage

### 1. Create action module
To handle the different actions from the Wit.ai API you have to create a module that implements the default callbacks and also custom actions if you have any.

The custom actions can be created by `defaction` macro. It expected to have three parameters i.e. `session` which is the session id, the `context` which contains the context of the conversation and `message` which is the raw message sent from Wit. **The name of the custom action should match the one registered in Wit.**

```elixir
defmodule WeatherActions do
  use Wit.Actions

  def say(session, context, message) do
    # Send the message to the user
  end

  def merge(session, context, message) do
    context # Return the updated context
  end

  def error(session, context, error) do
    # Handle error
  end

  defaction fetch_weather(session, context, message) do
    context # Return the updated context
  end
end

```

### 2. Call the run action
After you have create the action module you can call the Wit using the module which will keep on calling the wit `/converse` API until the API returns `stop`.

```elixir
Wit.run_actions(access_token, session_id, WeatherActions, "What is the weather?")
```

You can also use `interactive/4` which creates an interactive session with your model in Wit.

## Low Level APIs
The client also provides the functions to call the low level `message` and `converse` API.
