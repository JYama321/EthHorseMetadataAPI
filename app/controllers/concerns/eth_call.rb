module EthCall
    extend ActiveSupport::Concern
    require 'jsonclient'

    def getTokenMetadata(token_id)
        contractAddress = '0xce7ecd4b01a089709264ea186356d77c79c721a2'
        nftMetadataSelector='0x7aee8a84'
        tokenId = token_id.slice(2,64).rjust(64,'0')
        data = nftMetadataSelector + tokenId
        ethCallBody = {
            "jsonrpc": "2.0",
            "method": "eth_call",
            "params": [
                {
                to: contractAddress, // token contract address
                data,
            },
            'latest',
            ]
        }
        client = JSONClient.new
        res = client.post(
            ENV['INFURA_ROPSTEN'],
            {
                "Content-Type": "application/json",
                :body => ethCallBody
            }
            )
        JSON.parse(res.body)
    end

end
