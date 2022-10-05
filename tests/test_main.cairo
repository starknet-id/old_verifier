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
        stop_mock1 = mock_call(ids.STARKNETID_CONTRACT, "ownerOf", [123])
        stop_mock2 = mock_call(ids.STARKNETID_CONTRACT, "set_verifier_data", [])
    %}
    write_confirmation(
        Uint256(2, 0),
        28263441981469284,
        707979046952239197,
        (2821958939906103345738727000786131687662016840051168144541666097455074829329,
        874880325578455688131058050225162104651905718549748884038073811297955143089),
    );
    %{
        stop_prank_callable()
        stop_mock1()
        stop_mock2()
    %}
    return ();
}
