let g:VUNIT_ASSERT='VUNIT'

let g:out_file = 'output.txt'
let g:result_file = 'result.txt'

function! Test_Fail()
    call writefile(['FAILED'], g:result_file)
endfunction

function! Print_Title(title)
    call writefile([a:title], g:out_file, 'a')
endfunction

function! Print_Error(message)
    call writefile([' [\e[31mFAILED\e[0m] '.a:message], g:out_file, 'a')
endfunction

function! Print_Error_Msg(message)
    call writefile(['    -'.a:message], g:out_file, 'a')
endfunction

function! Print_Succes(message)
    call writefile([' [\e[32mSUCCES\e[0m] '.a:message], g:out_file, 'a')
endfunction

let g:Test={}
function g:Test.new()
    let l:newTest = copy(self)
    return l:newTest
endfunction

function g:Test.run()
    call Print_Title(self.name)
    for test_name in keys(self)
        if len(test_name) >=# 5 && test_name[0:4] ==# 'test_'
            call self.run_test(test_name)
        endif
    endfor
endfunction

function g:Test.run_test(test_name)
    try
        call self[a:test_name]()
        call Print_Succes(a:test_name)
    catch
        call Print_Error(a:test_name)

        if len(v:exception) >=# 5 && v:exception[0:4] ==# g:VUNIT_ASSERT
            call Print_Error_Msg(v:exception[5:])
        else
            call Print_Error_Msg(' Unexpected Exception: '.v:exception)
        endif

        call Test_Fail()
    endtry
endfunction

function g:Test.assert_equal(actual, expected, ...)
    let l:msg = 'Assert Equal: '.a:actual.' is not equal to '.a:expected
    if a:0 >=# 1
        let l:msg = a:1
    endif

    if a:actual !=# a:expected
        throw g:VUNIT_ASSERT.' '.l:msg
    endif
endfunction

function g:Test.assert_not_equal(actual, expected, ...)
    let l:msg = 'Assert Not Equal: '.a:actual.' is equal to '.a:expected
    if a:0 >=# 1
        let l:msg = a:1
    endif

    if a:actual ==# a:expected
        throw g:VUNIT_ASSERT.' '.l:msg
    endif
endfunction

let s:tests=[]
function! Test(name)
    let l:newTest = {}
    let l:newTest = extend(g:Test.new(), l:newTest)
    let l:newTest.name = a:name
    return l:newTest
endfunction

function! RegisterTest(test)
    call add(s:tests, a:test)
endfunction

function! Execute(files, out_file, result_file)
    let g:out_file = a:out_file
    let g:result_file = a:result_file

    for l:file in a:files
        try
            execute 'source '.l:file
        catch
            call Print_Error("Not able to source '".l:file."'")
            call Test_Fail()
            continue
        endtry
    endfor

    for test in s:tests
        call test.run()
    endfor
endfunction

