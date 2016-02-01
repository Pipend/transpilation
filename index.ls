Promise = require \bluebird
require! \babel-core
{compile} = require \livescript
{foldr1, keys, map} = require \prelude-ls
require! \vm

# execute-javascript :: String -> object -> [Error, a]
export execute-javascript-sync = (code, context) -->

    try 
        result = do ->
            if !!@window

                # use eval in the browser 
                context-code = context
                    |> keys 
                    |> map (key) -> 
                        mapped-key = key.replace \-, \_
                        "var #{mapped-key} = context['#{key}'];"
                    |> foldr1 (+)
                    |> -> it ? ""

                eval """
                    #{context-code}
                    #{code}
                """

            else

                # use vm module for nodejs
                vm.run-in-new-context code, context

        [null, result]

    catch err
        ["javascript runtime error: #{err.to-string!}", null]

# compile-and-execute-javascript :: String -> object -> [Error, a]
export compile-and-execute-babel-sync = (code, context) -->
    try 
        javascript-code = (babel-core.transform code, {plugins: ["transform-es2015-arrow-functions"]}) .code
            .replace '"use strict";', '' .trim!
            .replace "'use strict';", '' .trim!
    catch err 
        ["babel compilation error: #{err.to-string!}", null]

    execute-javascript-sync javascript-code, context

# compile-and-execute-livescript-sync :: String -> object -> [Error, a]
export compile-and-execute-livescript-sync = (livescript-code, context) -->
    try 
        javascript-code = (compile livescript-code, {bare: true, header: false})
    catch err
        ["livescript transpilation error: #{err.to-string!}", null]

    execute-javascript-sync javascript-code, context

# compile-and-execute-sync :: String -> String -> object -> [Error, a]
export compile-and-execute-sync = (code, language, context) ->
    # select the compiler based on the language
    (switch language
        | \livescript => compile-and-execute-livescript-sync
        | \javascript => execute-javascript-sync
        | \babel => compile-and-execute-babel-sync) do 
        "(\n#code\n)"
        context

# from-error-value-tuple :: (... -> [Error, a]) -> (... -> p a)
export from-error-value-tuple = (f) ->
    ->
        args = arguments
        context = @
        new Promise (res, rej) ->
            [err, result] = f.apply context, args
            if !!err then rej err else res result

# execute-javascript :: String, object -> p a
export execute-javascript = from-error-value-tuple execute-javascript-sync

# compile-and-execute-babel :: String, object -> p a
export compile-and-execute-babel = from-error-value-tuple compile-and-execute-babel-sync

# compile-and-execute-livescript :: String, object -> p a
export compile-and-execute-livescript = from-error-value-tuple compile-and-execute-livescript-sync

# compile-and-execute :: String, String, object -> p a
export compile-and-execute = from-error-value-tuple compile-and-execute-sync