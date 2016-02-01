assert = require \assert
Promise = require \bluebird
{keys} = require \prelude-ls
{
    execute-javascript-sync
    compile-and-execute-babel-sync
    compile-and-execute-livescript-sync
    compile-and-execute-sync
    from-error-value-tuple
    execute-javascript
    compile-and-execute-babel
    compile-and-execute-livescript
    compile-and-execute
} = require \../index.ls

describe \transpilation, ->

    # validate-sync :: [err, result] -> p String?
    validate-sync = ([err, result]) ->
        if !!err
            Promise.reject err

        else if result != 2
            Promise.reject "result must be 2 instead of #{result}"

        else 
            Promise.resolve null

    # validate :: p result -> p String?
    validate = (p) ->
        p.then (result) ->
            if result != 2 then Promise.reject "result must be 2 instead of #{result}" else null

    # returns-error-sync :: [Error, a] -> p String?
    returns-error-sync = ([err, result]) ->
        if !!err
            Promise.resolve null
        else
            Promise.reject "must throw err, instead returned result = #{result}"

    javascript = "a + 1"
    bad-javascript = "a + "
    babel = "addOne = (n) => {return n + 1}; addOne(a)"
    bad-babel = "addOne = (n) => {return n + 1; addOne(a)"
    livescript = "(+ 1) a"
    bad-livescript = "+ 1) a"
    context = a: 1

    specify \execute-javascript-sync, ->
        validate-sync (execute-javascript-sync javascript, context)

    specify 'execute-javascript-sync must return err', ->
        returns-error-sync (execute-javascript-sync bad-javascript, context)

    specify \compile-and-execute-babel-sync, ->
        validate-sync (compile-and-execute-babel-sync babel, context)

    specify 'compile-and-execute-babel-sync must return err', ->
        returns-error-sync (compile-and-execute-babel-sync bad-babel, context)

    specify \compile-and-execute-livescript-sync, ->
        validate-sync (compile-and-execute-livescript-sync livescript, context)

    specify 'compile-and-execute-livescript-sync must return err', ->
        returns-error-sync (compile-and-execute-livescript-sync bad-livescript, context)

    specify \compile-and-execute-sync, ->
        validate-sync (compile-and-execute-sync livescript, \livescript, context)

    specify \from-error-value-tuple, ->
        f = -> [null, 1]
        g = from-error-value-tuple f
        g!.then (result) -> 
            if result == 1 then null else "result must be 1, instead of #{result}"

    specify \execute-javascript, ->
        validate (execute-javascript javascript, context)

    specify \compile-and-execute-babel, ->
        validate (compile-and-execute-babel babel, context)

    specify \compile-and-execute-livescript, ->
        validate (compile-and-execute-livescript livescript, context)

    specify \compile-and-execute, ->
        validate (compile-and-execute livescript, \livescript, context)