#[recursive]
fn main(
    verification_key: [Field; 114],
    proof: [Field; 93],
    public_inputs: [Field; 1],
    key_hash: Field
) {
    // the client side circuit returns a valid proof whether the code is valid or not
    // but it also returns 0 if the code is valid and non-zero otherwise as public input
    // this could incentive bad actors to use bad codes and modify the public inputs
    // first check that its output was 0
    assert(public_inputs[0] == 0);

    // then aggregate its proof
    dep::std::verify_proof(
        verification_key.as_slice(),
        proof.as_slice(),
        public_inputs.as_slice(),
        key_hash
    );
    // even with bad public inputs, the proof should aggregate but fail to verify
}
