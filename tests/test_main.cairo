%lang starknet
from src.main import write_confirmation, STARKNETID_CONTRACT
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256

@external
func test_write_confirmation{
    syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, ecdsa_ptr : SignatureBuiltin*
}():
    %{
        stop_prank_callable = start_prank(123)
        stop_mock1 = mock_call(ids.STARKNETID_CONTRACT, "ownerOf", [123])
        stop_mock2 = mock_call(ids.STARKNETID_CONTRACT, "set_verifier_data", [])
    %}
    write_confirmation(
        Uint256(1, 0),
        32782392107492722,
        707979046952239197,
        (1653886122397423841049805791319762475317892980419374860359669205268389148313, 2422985777404453695024857014265960150607878912997744768559585804023017268051),
    )
    %{
        stop_prank_callable()
        stop_mock1()
        stop_mock2()
    %}
    return ()
end
