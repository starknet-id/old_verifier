%lang starknet
from starkware.cairo.common.math import assert_nn
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.signature import verify_ecdsa_signature

const STARKNETID_CONTRACT = 0x04564121a7ad7757c425e4dac1a855998bf186303107d1c28edbf0de420e7023
const PUBLIC_KEY = 1576987121283045618657875225183003300580199140020787494777499595331436496159

@contract_interface
namespace StarknetID:
    func confirm_validity(token_id : felt, field : felt, data : felt):
    end
end

@external
func write_confirmation{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}(token_id : felt, field : felt, data : felt, sig : (felt, felt)):
    # message_hash = hash2(hash2(token_id, field), data)
    let (message_hash) = hash2{hash_ptr=pedersen_ptr}(token_id, field)
    let (message_hash) = hash2{hash_ptr=pedersen_ptr}(message_hash, data)
    verify_ecdsa_signature(message_hash, PUBLIC_KEY, sig[0], sig[1])
    StarknetID.confirm_validity(STARKNETID_CONTRACT, token_id, field, data)
    return ()
end
