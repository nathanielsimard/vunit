let g:SimpleTest = Test('Simple Test')

function g:SimpleTest.test_assert_equal_fail()
    call self.assert_equal(1, 0)
endfunction

function g:SimpleTest.test_assert_equal_succeed()
    call self.assert_equal(0, 0)
endfunction

call RegisterTest(g:SimpleTest.new())

