//
//  MemeAPI.swift
//  MemeMe
//
//  Created by Perica on 22.03.18.
//  Copyright © 2018 Boris. All rights reserved.
//

import Foundation

/**
 Global access point for adding/retrieving and updating Memes
 Singleton!
 */
final class MemeAPI {
    
    static let shared = MemeAPI()
    private let persistencyManager = PersistencyManager()
    
    private init() {
    }
    
    func getMemes() -> [Meme] {
        return persistencyManager.getMemes()
    }
    
    func addMeme(_ meme: Meme) {
        persistencyManager.addMeme(meme)
    }
    
    func addMeme(_ meme: Meme, at index: Int) {
        persistencyManager.addMeme(meme, at: index)
    }
    
    func deleteMeme(at index: Int) {
        persistencyManager.deleteMeme(at: index)
    }
    
}
