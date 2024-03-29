//
//  TextureLibrary.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/16/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

enum TextureTypes{
    case None
    case Test
    
    case Cruiser_Base
    
    //Sand
    case Sand_Base
    case Sand_Normal
    case Sand_Specular
    case Sand_Ambient
    case Sand_Height
    case Sand_Height_Inverted
    
    case Helmet_Albedo
}

class TextureLibrary: Library<TextureTypes, MTLTexture> {
    private var library: [TextureTypes : Texture] = [:]
    
    override func fillLibrary() {
        library.updateValue(Texture("bird", origin: .topLeft), forKey: .Test)

        library.updateValue(Texture("cruiser", ext: "bmp", origin: .bottomLeft), forKey: .Cruiser_Base)
        
        // Sand
        library.updateValue(Texture("sand_basecolor", origin: .bottomLeft), forKey: .Sand_Base)
        library.updateValue(Texture("sand_normal", origin: .bottomLeft), forKey: .Sand_Normal)
        library.updateValue(Texture("sand_glossiness", origin: .bottomLeft), forKey: .Sand_Specular)
        library.updateValue(Texture("sand_ambient_occlusion", origin: .bottomLeft), forKey: .Sand_Ambient)
        library.updateValue(Texture("sand_height", origin: .bottomLeft), forKey: .Sand_Height)
        library.updateValue(Texture("sand_height", origin: .topLeft), forKey: .Sand_Height_Inverted)
        
        //Helmet
        library.updateValue(Texture("Default_albedo", ext: "jpg", origin: .bottomLeft), forKey: .Helmet_Albedo)
    }
    
    override subscript(_ type: TextureTypes) -> MTLTexture? {
        return library[type]?.texture
    }
}

class Texture {
    var texture: MTLTexture!
    
    init(_ textureName: String, ext: String = "png", origin: MTKTextureLoader.Origin = .topLeft){
        let textureLoader = TextureLoader(textureName: textureName, textureExtension: ext, origin: origin)
        let texture: MTLTexture = textureLoader.loadTextureFromBundle()
        setTexture(texture)
    }
    
    func setTexture(_ texture: MTLTexture){
        self.texture = texture
    }
}

class TextureLoader {
    private var _textureName: String!
    private var _textureExtension: String!
    private var _origin: MTKTextureLoader.Origin!
    
    init(textureName: String, textureExtension: String = "png", origin: MTKTextureLoader.Origin = .topLeft){
        self._textureName = textureName
        self._textureExtension = textureExtension
        self._origin = origin
    }
    
    public func loadTextureFromBundle()->MTLTexture{
        var result: MTLTexture!
        if let url = Bundle.main.url(forResource: _textureName, withExtension: self._textureExtension) {
            let textureLoader = MTKTextureLoader(device: Engine.Device)
            
            let options: [MTKTextureLoader.Option : MTKTextureLoader.Origin] = [MTKTextureLoader.Option.origin : _origin]
            
            do{
                result = try textureLoader.newTexture(URL: url, options: options)
                result.label = _textureName
            }catch let error as NSError {
                print("ERROR::CREATING::TEXTURE::__\(_textureName!)__::\(error)")
            }
        }else {
            print("ERROR::CREATING::TEXTURE::__\(_textureName!) does not exist")
        }
        
        return result
    }
}
