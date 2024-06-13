fn main(code: [Field; 13]) {
    assert(dep::ro_cnp::is_valid(code) == true);
}

#[test]
fn test_ok() {
    // random code
    main([1, 7, 7, 1, 1, 2, 6, 4, 1, 0, 5, 7, 0])
}

#[test(should_fail)]
fn test_not_ok() {
    // same as above but with a bad control digit
    main([1, 7, 7, 1, 1, 2, 6, 4, 1, 0, 5, 7, 1])
}

