module ImageSynth
    extend ActiveSupport::Concern
    require 'RMagick'
    TexturesRate = {
        normal_rate: ['a','b','c','d','f','g','h','i','j','r','s','t','u','w','y'],
        slightly_rare: ['p','l','m','n','o'],
        rare: ['p','l','m','n','o'],
    }
    FaceAndHairTextures = {
        face: ['_1_1','_2_1','_3_1','_4_1','_5_1','_6_1','_7_1','_8_1'],
        hair: ['_1,7_2','_2_2','_3_2','_4_2','_5_2','_6,8_2','_1,7_2','_6,8_2']
    }
    BaseTextureImagePath = {
        origin: "storage/origins/origin",
        parts: "storage/textures/"
    }
    #ベースのイメージに対する大きさ(%),width,height, left, top
    # [[[w1,h1,l1,t1],[w2,h2,l2,t2]...,[[w1,h1,l1,t1],[w2,h2,l2,t2],[[w1,h1,l1,t1],[w2,h2,l2,t2]]]
    ImageResizeAndPositionRate = [
        [[0.285,0.438,0,0.4],[0.469,0.450,0.042,0],[0.358,0.302,0.268,0.364],[0.154,0.557,0.15,0.378],[0.308,0.608,0.54,0.347],[0.303,0.235,0.695,0.358]],
        [[0.285,0.438,0,0.4],[0.469,0.450,0.042,0],[0.358,0.302,0.268,0.364],[0.154,0.557,0.15,0.378],[0.308,0.608,0.54,0.347],[0.303,0.235,0.695,0.358]],
        [[0.3, 0.36,0,0.12],[0.461,0.45,0.059,0],[0.346,0.3,0.282,0.364],[0.148,0.562,0.168,0.371],[0.308,0.608,0.54,0.347],[0.303,0.235,0.695,0.358]],
        [[0.3,0.34,0,0.134],[0.461,0.45,0.059,0],[0.346,0.3,0.282,0.364],[0.148,0.562,0.168,0.371],[0.308,0.608,0.54,0.347],[0.303,0.235,0.695,0.358]],
        [[0.285,0.38,0.038,0.1],[0.451,0.45,0.088,0],[0.333,0.306,0.308,0.364],[0.144,0.555,0.196,0.38],[0.292,0.608,0.56,0.347],[0.303,0.235,0.695,0.358]],
        [[0.285,0.438,0,0.4],[0.469,0.450,0.042,0],[0.358,0.302,0.268,0.364],[0.154,0.557,0.15,0.378],[0.308,0.608,0.54,0.347],[0.303,0.235,0.695,0.358]],
        [[0.285,0.438,0,0.4],[0.469,0.450,0.042,0],[0.358,0.302,0.268,0.364],[0.154,0.557,0.15,0.378],[0.308,0.608,0.54,0.347],[0.303,0.235,0.695,0.358]],
        [[0.285,0.438,0,0.4],[0.469,0.450,0.042,0],[0.358,0.302,0.268,0.364],[0.154,0.557,0.15,0.378],[0.308,0.608,0.54,0.347],[0.303,0.235,0.695,0.358]]
    ]
    ImageOriginSize = [
        [3512,2872],[3524,2885],[3595,2877],[3575,2871],[3711,2877],[3530,2876],[3519,2870],[3520,2877]
    ]
    def create_image(texture_info)
        originSize = ImageOriginSize[texture_info[:origin_type]-1]
        rpRate = ImageResizeAndPositionRate[texture_info[:origin_type]-1]
        puts texture_info[:texture_paths[5]]
        base = Magick::ImageList.new(texture_info[:texture_paths][5])
        imageOrigin = Magick::ImageList.new(texture_info[:texture_paths][5])
        imageHead = Magick::ImageList.new(texture_info[:texture_paths][0])
        imageHair = Magick::ImageList.new(texture_info[:texture_paths][1])
        imageBody = Magick::ImageList.new(texture_info[:texture_paths][2])
        imageLegFront = Magick::ImageList.new(texture_info[:texture_paths][3])
        imageLegBack = Magick::ImageList.new(texture_info[:texture_paths][3].gsub("4","5"))
        imageTail = Magick::ImageList.new(texture_info[:texture_paths][4].gsub("5","6"))
        puts "originsize: ", originSize
        resizedImages = [
            resize_image(originSize,imageHead,rpRate[0][0], rpRate[0][1]),
            resize_image(originSize,imageHair,rpRate[1][0],rpRate[1][1]),
            resize_image(originSize,imageBody,rpRate[2][0],rpRate[2][1]),
            resize_image(originSize,imageLegFront,rpRate[3][0],rpRate[3][1]),
            resize_image(originSize, imageLegBack,rpRate[4][0], rpRate[4][1]),
            resize_image(originSize, imageTail,rpRate[5][0],rpRate[5][1])
        ]
        puts "image resized", resizedImages
        resizedImages.each_with_index do |img, index|
            imageOrigin = imageOrigin.composite(img,originSize[0] * rpRate[index][2],originSize[1] * rpRate[index][3], Magick::OverCompositeOp)
        end
        imageOut = imageOrigin.composite(base, 0, 0, Magick::OverCompositeOp)
        imageOut.write(texture_info[:image_path])
    end

    # originSize[w,h], targetImage(Magick::ImageList), w,h(%)
    def resize_image(originSize,targetImg,w,h)
        return targetImg.resize(originSize[0] * w, originSize[1] * h)
    end

    # baseimage, composed image, left, top(%)
    def compositeImage(baseImg,targetImg, l,t)
        return baseImg.composite(targetImg, l, t, Magick::OverCompositeOp)
    end


    def gene_to_image_info(gene="0000000000000000000000000000000000000000000000000000000000000000")
        texture_info = {
            texture_paths: [],
            texture_names: [],
            image_path: "",
            origin_type: 1,
        }
        genePieces = [gene.slice(0,3),gene.slice(3,3),gene.slice(6,3),gene.slice(9,3),gene.slice(12,3),gene.slice(15,3)]
        genePieces.each_with_index do |elem, i|
            num = elem.to_i
            if i <= 4 then
                if num < 870 then
                    index = (elem.to_i / 58).floor
                    texture_info[:texture_names].push(TexturesRate[:normal_rate][index])
                    texture_info[:texture_paths].push(BaseTextureImagePath[:parts] + TexturesRate[:normal_rate][index] + (i+1).to_s + ".png")
                elsif num < 970 then
                    index = ((elem.to_i - 870) / 20).floor
                    texture_info[:texture_names].push(TexturesRate[:slightly_rare][index])
                    texture_info[:texture_paths].push(BaseTextureImagePath[:parts] + TexturesRate[:normal_rate][index] + (i+1).to_s + ".png")
                else
                    index = ((num - 970)/ 10).floor
                    texture_info[:texture_names].push(TexturesRate[:rare][index])
                    texture_info[:texture_paths].push(BaseTextureImagePath[:parts] + TexturesRate[:normal_rate][index] + (i+1).to_s + ".png")
                end
            else
                # origin
                texture_info[:texture_names].push(((num / 125).floor + 1))
                texture_info[:texture_paths].push(BaseTextureImagePath[:origin] + texture_info[:texture_names][5].to_s + "_2.png")
                texture_info[:texture_names][0] = texture_info[:texture_names][0] + FaceAndHairTextures[:face][texture_info[:texture_names][5] - 1]
                texture_info[:texture_paths][0] = BaseTextureImagePath[:parts] + texture_info[:texture_names][0] + ".png"
                texture_info[:texture_names][1] = texture_info[:texture_names][1] + FaceAndHairTextures[:hair][texture_info[:texture_names][5] - 1]
                texture_info[:texture_paths][1] = BaseTextureImagePath[:parts] + texture_info[:texture_names][1] + ".png"
                texture_info[:image_path] = "storage/" + genePieces.join("") + ".png"
                texture_info[:origin_type] = (num / 125).floor + 1
            end
        end
        return texture_info
    end

end

