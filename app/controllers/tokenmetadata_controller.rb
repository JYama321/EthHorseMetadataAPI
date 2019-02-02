class TokenmetadataController < ApplicationController
    def tokeninfo
        @id = params[:id]
        if @token = TokenCreated.find_by(tokenId: @id)
            # TODO: トークンがすでに存在してる時はそのまま返す
        else
            # TODO: トークンがまだないときは画像を作る処理
        end
        render 'tokeninfo', formats: 'json', handlers: 'jbuilder'        
    end

    def token_image
        send_file 'storage/sample_token1.png', type: 'image/png', disposition: 'inline'
    end
end
