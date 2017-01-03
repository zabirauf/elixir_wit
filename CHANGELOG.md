Changelog
=============

# 1.0.0

* Backward incompatible changes
  * Change `entities` type to `map` in `Wit.Models.Response.Converse` and `Wit.Models.Response.Outcome`
  * Changed function signature for custom action to pass in the `message`
    ```elixir
    defaction fetch_weather(session, context, message) do
        context # Return the updated context
    end
    ```
    
