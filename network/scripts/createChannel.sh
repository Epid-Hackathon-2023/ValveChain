# Genesis
# Create
# Join
# Set Anchor

# imports
. scripts/envVar.sh

CHANNEL_NAME=$1
DELAY="3"
MAX_RETRY="5"


if [ ! -d "channel-artifacts" ]; then
    mkdir channel-artifacts
fi

createGenesisBlock() {
    configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
}

createChannel() {
    setGlobals 1

    osnadmin channel join --channelID $CHANNEL_NAME --config-block ./channel-artifacts/${CHANNEL_NAME}.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >&log.txt
    cat log.txt
}


FABRIC_CFG_PATH=${PWD}/../config

createGenesisBlock
createChannel
