assert = require \assert
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

    # validate-sync :: [err, result] -> a -> p String?
    validate-sync = ([err, result], expected-result = 2) ->
        if !!err
            Promise.reject err

        else if result != expected-result
            Promise.reject "result must be #{expected-result} instead of #{result}"

        else 
            Promise.resolve null

    # validate :: p result -> a -> p String?
    validate = (p, expected-result = 2) ->
        p.then (result) ->
            if result != expected-result 
                Promise.reject "result must be #{expected-result} instead of #{result}" 
            else 
                null

    # returns-error-sync :: [Error, a] -> p String?
    returns-error-sync = ([err, result]) ->
        if !!err
            Promise.resolve null
        else
            Promise.reject "must throw err, instead returned result = #{result}"

    javascript = "a + 1"
    bad-javascript = "a + "
    babel = """
    let factorial = (n, acc = 1) => {
      if (n <= 1) return acc;
      return factorial(n - 1, n * acc);
    }

    factorial(10)
    """
    bad-babel = "addOne = (n) => {return n + 1; addOne(a)"
    livescript = "(+ 1) a"
    bad-livescript = "+ 1) a"
    context = a: 1

    specify \execute-javascript-sync, ->
        validate-sync (execute-javascript-sync javascript, context)

    specify 'execute-javascript-sync must return err', ->
        returns-error-sync (execute-javascript-sync bad-javascript, context)

    specify \compile-and-execute-babel-sync, ->
        validate-sync (compile-and-execute-babel-sync babel, context), 3628800

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
        validate (compile-and-execute-babel babel, context), 3628800

    specify \compile-and-execute-livescript, ->
        validate (compile-and-execute-livescript livescript, context)

    specify \compile-and-execute, ->
        validate (compile-and-execute livescript, \livescript, context)