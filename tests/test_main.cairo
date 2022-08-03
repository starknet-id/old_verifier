%lang starknet
from src.main import write_confirmation, STARKNETID_CONTRACT
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin

@external
func test_write_confirmation{
    syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, ecdsa_ptr : SignatureBuiltin*
}():
    %{ stop_mock = mock_call(ids.STARKNETID_CONTRACT, "confirm_validity", []) %}
    write_confirmation(
        1,
        32782392107492722,
        707979046952239197,
        (3080839013257917388912427272007960968983330462333836515539201615307211653072, 89679567102290128469246051304611027815698436897600596965054556492202657962),
    )
    %{ stop_mock() %}
    return ()
end
