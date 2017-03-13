Changelog
=============

# 2.0.0
* Update to Elixir 1.4
* Update to Wit API 20160526
* Refactor tests to load Wit access token from Mix config
* Backward incompatible changes
    - Remove the `outcomes` from `message` responses and replace with `entities`

# 1.0.0

* Backward incompatible changes
  * Change `entities` type to `map` in `Wit.Models.Response.Converse` and `Wit.Models.Response.Outcome`
  * Changed function signature for custom action to pass in the `message`
    ```elixir
    defaction fetch_weather(session, context, message) do
        context # Return the updated context
    end
    ```
    
