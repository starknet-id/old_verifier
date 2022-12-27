from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.gateway_client import GatewayClient
from starknet_py.net.udc_deployer.deployer import Deployer
from starknet_py.net import AccountClient, KeyPair
import asyncio
import json
import sys

argv = sys.argv

deployer_account_addr = (
    0x048F24D0D0618FA31813DB91A45D8BE6C50749E5E19EC699092CE29ABE809294
)
deployer_account_private_key = int(argv[1])
# MAINNET: https://alpha-mainnet.starknet.io/
# TESTNET: https://alpha4.starknet.io/
# TESTNET2: https://alpha4-2.starknet.io/
network_base_url = "https://alpha4.starknet.io/"
chainid: StarknetChainId = StarknetChainId.TESTNET
max_fee = int(1e16)
deployer = Deployer()
starknetid_contract = 0x783A9097B26EAE0586373B2CE0ED3529DDC44069D1E0FBC4F66D42B69D6850D
public_key = (
    1576987121283045618657875225183003300580199140020787494777499595331436496159
)


async def main():
    client = GatewayClient(
        net={
            "feeder_gateway_url": network_base_url + "feeder_gateway",
            "gateway_url": network_base_url + "gateway",
        }
    )
    account: AccountClient = AccountClient(
        client=client,
        address=deployer_account_addr,
        key_pair=KeyPair.from_private_key(deployer_account_private_key),
        chain=chainid,
        supported_tx_version=1,
    )

    verifier_file = open("./build/verifier.json", "r")
    verifier_content = verifier_file.read()
    verifier_file.close()
    declare_contract_tx = await account.sign_declare_transaction(
        compiled_contract=verifier_content, max_fee=max_fee
    )
    verifier_declaration = await client.declare(transaction=declare_contract_tx)
    verifier_json = json.loads(verifier_content)
    abi = verifier_json["abi"]
    print("verifier class hash:", hex(verifier_declaration.class_hash))
    deploy_call, address = deployer.create_deployment_call(
        class_hash=verifier_declaration.class_hash,
        abi=abi,
        calldata={
            "starknetid_contract": starknetid_contract,
            "public_key": public_key,
        },
    )

    resp = await account.execute(deploy_call, max_fee=int(1e16))
    print("deployment txhash:", hex(resp.transaction_hash))
    print("verifier contract address:", hex(address))


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
