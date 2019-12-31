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

let s:Result={}
function s:Result.new()
    let l:newResult = copy(self)
    let l:newResult.succeed = 0
    let l:newResult.failed = 0
    return l:newResult
endfunction

function s:Result.add_succes()
    let self.succeed = self.succeed + 1
endfunction

function s:Result.add_failure()
    let self.failed = self.failed + 1
endfunction

function s:Result.print()
    call Print_Title('Result - '.self.succeed.' Success '.self.failed.' Failures')
endfunction

let g:Test={}
function g:Test.new(result)
    let l:newTest = copy(self)
    let l:newTest.result = a:result
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
        if has_key(self, 'before_each')
            call self.before_each()
        endif

        call self[a:test_name]()

        if has_key(self, 'after_each')
            call self.after_each()
        endif

        call Print_Succes(a:test_name[5:])
        call self.result.add_succes()
    catch
        call Print_Error(a:test_name[5:])

        if len(v:exception) >=# 5 && v:exception[0:4] ==# g:VUNIT_ASSERT
            call Print_Error_Msg(v:exception[5:])
        else
            call Print_Error_Msg(' Unexpected Exception: '.v:exception)
        endif

        call Test_Fail()
        call self.result.add_failure()
    endtry
endfunction

function g:Test.assert_true(actual, ...)
    let l:msg = 'Assert True: "'.string(a:actual).'" is not true'
    if a:0 >=# 1
        let l:msg = a:1
    endif

    if a:actual !=# 1
        throw g:VUNIT_ASSERT.' '.l:msg
    endif
endfunction

function g:Test.assert_false(actual, ...)
    let l:msg = 'Assert False: "'.string(a:actual).'" is not false'
    if a:0 >=# 1
        let l:msg = a:1
    endif

    if a:actual !=# 0
        throw g:VUNIT_ASSERT.' '.l:msg
    endif
endfunction

function g:Test.assert_equal(actual, expected, ...)
    let l:msg = 'Assert Equal: '.string(a:actual).' is not equal to '.string(a:expected)
    if a:0 >=# 1
        let l:msg = a:1
    endif

    if a:actual !=# a:expected
        throw g:VUNIT_ASSERT.' '.l:msg
    endif
endfunction

function g:Test.assert_not_equal(actual, expected, ...)
    let l:msg = 'Assert Not Equal: '.string(a:actual).' is equal to '.string(a:expected)
    if a:0 >=# 1
        let l:msg = a:1
    endif

    if a:actual ==# a:expected
        throw g:VUNIT_ASSERT.' '.l:msg
    endif
endfunction

let s:tests=[]
let s:result=s:Result.new()

function! Test(name)
    let l:newTest = {}
    let l:newTest = extend(g:Test.new(s:result), l:newTest)
    let l:newTest.name = a:name
    call add(s:tests, l:newTest)
    return l:newTest
endfunction

function! Execute(files, out_file, result_file)
    let g:out_file = a:out_file
    let g:result_file = a:result_file

    for l:file in a:files
        try
            execute 'source '.l:file
        catch
            call Print_Error("Not able to source '".l:file."'")
            call Print_Error_Msg(v:exception)
            call Test_Fail()
            continue
        endtry
    endfor

    for test in s:tests
        let l:result = test.run()
    endfor
    call s:result.print()
endfunction

