#[recursive]
fn main(code: [Field; 13]) -> pub Field {
    // unix style 0 for success, non-zero for failure
    // it's the responsibility of the next circuit to verify both the proof and the return value
    if dep::ro_cnp::is_valid(code) { 0 } else { 1 }
}
