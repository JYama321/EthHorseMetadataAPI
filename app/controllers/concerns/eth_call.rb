module EthCall
    extend ActiveSupport::Concern
    require 'jsonclient'

    def getTokenMetadata(token_id)
        contractAddress = '0x262fdab75f0db9b3cebe7a24684002e415454807'
        nftMetadataSelector='0x7aee8a84'
        data = nftMetadataSelector + token_id
        #TODO: nftかどうかの判定を追加する
        ethCallBody = {
            "jsonrpc": "2.0",
            "id": "1.0",
            "method": "eth_call",
            "params": [
                {
                to: contractAddress, # token contract address
                data: data,
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
        res.body
    end

end
