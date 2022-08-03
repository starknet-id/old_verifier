from starkware.crypto.signature.fast_pedersen_hash import pedersen_hash
from starkware.crypto.signature.signature import private_to_stark_key, sign

# 1576987121283045618657875225183003300580199140020787494777499595331436496159
def get_public_key(private_key):
    return private_to_stark_key(private_key)

# input: 1, 0, 32782392107492722, 707979046952239197, priv_key
# output: (3080839013257917388912427272007960968983330462333836515539201615307211653072, 89679567102290128469246051304611027815698436897600596965054556492202657962)
def generate_signature(token_id_low, token_id_high, type, data, private_key):
    hash = pedersen_hash(pedersen_hash(pedersen_hash(token_id_low, token_id_high), type), data)
    signed = sign(hash, private_key)
    return signed
