%lang starknet
from starkware.cairo.common.math import assert_nn
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.signature import verify_ecdsa_signature
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from starkware.cairo.common.math import assert_le_felt

const STARKNETID_CONTRACT = 0x0798e884450c19e072d6620fefdbeb7387d0453d3fd51d95f5ace1f17633d88b;
const PUBLIC_KEY = 1576987121283045618657875225183003300580199140020787494777499595331436496159;

@storage_var
func blacklisted_point(r) -> (blacklisted: felt) {
}

@contract_interface
namespace StarknetID {
    func ownerOf(token_id: felt) -> (owner: felt) {
    }

    func set_verifier_data(token_id: felt, field: felt, data: felt) {
    }
}

@external
func write_confirmation{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}(token_id: felt, timestamp: felt, field: felt, data: felt, sig: (felt, felt)) {
    let (caller) = get_caller_address();
    let (owner) = StarknetID.ownerOf(STARKNETID_CONTRACT, token_id);

    assert caller = owner;

    // ensure confirmation is not expired
    let (current_timestamp) = get_block_timestamp();
    assert_le_felt(current_timestamp, timestamp);

    let (is_blacklisted) = blacklisted_point.read(sig[0]);
    assert is_blacklisted = 0;
    // blacklisting r should be enough since it depends on the "secure random point" it should never be used again
    // to anyone willing to improve this check in the future, please be careful with s, as (r, -s) is also a valid signature
    blacklisted_point.write(sig[0], 1);

    // message_hash = hash2(hash2(hash2(token_id, 0), field), data)
    let (message_hash) = hash2{hash_ptr=pedersen_ptr}(token_id, 0);
    let (message_hash) = hash2{hash_ptr=pedersen_ptr}(message_hash, field);
    let (message_hash) = hash2{hash_ptr=pedersen_ptr}(message_hash, data);
    verify_ecdsa_signature(message_hash, PUBLIC_KEY, sig[0], sig[1]);
    StarknetID.set_verifier_data(STARKNETID_CONTRACT, token_id, field, data);
    return ();
}
