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

    local rc=1
    local COUNTER=1

    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
        sleep $DELAY

        osnadmin channel join --channelID $CHANNEL_NAME --config-block ./channel-artifacts/${CHANNEL_NAME}.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >&log.txt
        res=$?
        let rc=$res
        COUNTER=$(expr $COUNTER + 1)
    done
    
    cat log.txt
}

joinChannel() {
    ORG=$1
    setGlobals $ORG

    local rc=1
    local COUNTER=1

    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
        sleep $DELAY

        peer channel join -b $BLOCKFILE > log.txt

        res=$?
        let rc=$res
        COUNTER=$(expr $COUNTER + 1)
    done
}

FABRIC_CFG_PATH=${PWD}/../config
BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

createGenesisBlock
createChannel

joinChannel 1
joinChannel 2