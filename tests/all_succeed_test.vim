let g:SucceedTest = Test('Succeed Test')

function g:SucceedTest.test_assert_equal_succeed()
    call self.assert_equal(0, 0)
endfunction

function g:SucceedTest.test_assert_not_equal_succeed()
    call self.assert_not_equal(1, 0)
endfunction

call RegisterTest(g:SucceedTest)

