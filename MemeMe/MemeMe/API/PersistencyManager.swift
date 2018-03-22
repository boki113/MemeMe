//
//  PersistencyManager.swift
//  MemeMe
//
//  Created by Perica on 22.03.18.
//  Copyright © 2018 Boris. All rights reserved.
//

import Foundation

/**
 Use this to get/add/delete memes directly.
 Should only be used via an API like MemeAPI
 */
final class PersistencyManager {
    
    private var memes = [Meme]()
    
    func getMemes() -> [Meme] {
        return memes
    }
    
    func addMeme(_ meme: Meme, at index: Int) {
        if memes.count >= index {
            memes.insert(meme, at: index)
            
            return
        }
        
        addMeme(meme)
    }
    
    func addMeme(_ meme: Meme) {
        memes.append(meme)
    }
    
    func deleteMeme(at index: Int) {
        memes.remove(at: index)
    }
}
