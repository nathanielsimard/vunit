let g:TrowTest = Test('Throwing Test')

function g:TrowTest.test_throw_fail()
    throw 'An exception'
endfunction

function g:TrowTest.test_throw_succeed()
    try
        throw 'An exception'
    catch
        call self.assert_equal('An exception', v:exception)
    endtry
endfunction

call RegisterTest(g:TrowTest)

