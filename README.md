# Functions

* `execute-javascript-sync :: JavascriptCode::String -> Context::object -> [Error, result]`

* `compile-and-execute-babel-sync :: BabelCode::String -> Context::object -> [Error, result]`

* `compile-and-execute-livescript-sync :: LivescriptCode::String -> Context::object -> [Error, result]`

* `compile-and-execute-sync :: Code::String, Language::String, Context::object -> [Error, result]`

* `from-error-value-tuple :: Promise p => (... -> [Error, a]) -> (... -> p a)`
  converts a function that returns [Error, a] into a function that returns a Promise a

* `execute-javascript :: JavascriptCode::String, Context::object -> p result`

* `compile-and-execute-babel :: BabelCode::String, Context::object -> p result`

* `compile-and-execute-livescript :: LivescriptCode::String, Context::object -> p result`

* `compile-and-execute :: Code::String, Language::String, Context::object -> p result`

# Test

`npm test`