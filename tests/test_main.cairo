%lang starknet
from src.main import write_confirmation, STARKNETID_CONTRACT
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256

@external
func test_write_confirmation{
    syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*, ecdsa_ptr: SignatureBuiltin*
}() {
    %{
        stop_prank_callable = start_prank(123)
        print("toto1:", ids.STARKNETID_CONTRACT)
        stop_mock1 = mock_call(ids.STARKNETID_CONTRACT, "owner_of", [123])
        stop_mock2 = mock_call(ids.STARKNETID_CONTRACT, "set_verifier_data", [])
    %}
    write_confirmation(
        1,
        2 ** 128,
        32782392107492722,
        707979046952239197,
        (242178274510413660320776612725275530442992398463760124282759555533509261346, 3369339735225989044856582139053547932849348534803432731455132141425388526099),
    );
    %{
        stop_prank_callable()
        stop_mock1()
        stop_mock2()
    %}
    return ();
}
