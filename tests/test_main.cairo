%lang starknet
from src.main import write_confirmation, _public_key
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256

@external
func test_write_confirmation{
    syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*, ecdsa_ptr: SignatureBuiltin*
}() {
    _public_key.write(1576987121283045618657875225183003300580199140020787494777499595331436496159);
    %{
        stop_prank_callable = start_prank(123)
        stop_mock1 = mock_call(0, "owner_of", [123])
        stop_mock2 = mock_call(0, "set_verifier_data", [])
    %}
    write_confirmation(
        1,
        2 ** 128,
        32782392107492722,
        707979046952239197,
        (
            242178274510413660320776612725275530442992398463760124282759555533509261346,
            3369339735225989044856582139053547932849348534803432731455132141425388526099,
        ),
    );
    %{
        stop_prank_callable()
        stop_mock1()
        stop_mock2()
    %}
    return ();
}
