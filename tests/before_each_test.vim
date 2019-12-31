let g:BeforeEachTest = Test('Before Each Test')

function g:BeforeEachTest.before_each()
    let self.expected = 0
endfunction

function g:BeforeEachTest.after_each()
    let self.expected = 1
endfunction

function g:BeforeEachTest.test_assert_equal_succeed()
    call self.assert_equal(0, self.expected)
endfunction

function g:BeforeEachTest.test_assert_not_equal_succeed()
    call self.assert_not_equal(1, self.expected)
endfunction

