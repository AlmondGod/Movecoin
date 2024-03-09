require('dotenv').config(); 

const client = new BlockchainClient({
    rpcEndpoint: process.env.RPC_ENDPOINT,
});