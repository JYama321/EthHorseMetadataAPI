class TokenmetadataController < ApplicationController
    include ImageSynth
    def tokeninfo
        @id = params[:id]
        @image = "https://ethhorse-metadata.herokuapp.com/token/#{@id}/image/33333333333333333333333333333333"
        @name = "King Horse"
        @isNFT = false
        @attributes = [{
            :key => "体力",
            :value => 45,
            :detail => "体力そこそこ"
        },{
            :key => "最高速度",
            :value => "32",
            :detail => "まあまあ"
        }]
        @contract_address = "0x8105C860608c81d27a24C9Aa08533c00deF38BD0"
        if @token = TokenCreated.find_by(tokenId: @id)
            # TODO: トークンがすでに存在してる時はそのまま返す
        else
            # TODO: トークンがまだないときは画像を作る処理
        end
        render 'tokeninfo', formats: 'json', handlers: 'jbuilder'        
    end

    def token_image
        gene = params[:gene]
        image_info = gene_to_image_info(gene)
        if File.exist?(image_info[:image_path])
            send_file image_info[:image_path], type: 'image/png', disposition: 'inline'
        else
            create_image(image_info)
            send_file image_info[:image_path], type: 'image/png', disposition: 'inline'
        end
    end

    def icon
        image_path="storage/icon.png"
        send_file image_path, type: 'image/png', disposition: 'inline'
    end
end
