class TokenmetadataController < ApplicationController
    include ImageSynth
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
        gene = params[:gene]
        image_info = gene_to_image_info(gene)
        if File.exist?(image_info[:image_path])
            send_file image_info[:image_path], type: 'image/png', disposition: 'inline'
        else
            create_image(image_info)
            send_file image_info[:image_path], type: 'image/png', disposition: 'inline'
        end
    end
end
