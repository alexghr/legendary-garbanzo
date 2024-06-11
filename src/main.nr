fn main(code: [Field; 13]) {
    let index = [2, 7, 9, 1, 4, 6, 3, 5, 8, 2, 7, 9];
    let modulo = 11;
    let mut sum = 0;
    for i in 0..12 {
        sum += code[i] * index[i];
    }

    let remainder = ((sum as u32) % modulo) as Field;
    let control = if remainder == 10 { 1 } else { remainder };
    assert(code[12] == control);
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

