//
//  UserData.swift
//  SetGame
//
//  Created by Alexander Ushakov on 06/01/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import Foundation

class UserData: Codable {

    var musicSet = true
    var soundFXSet = true
    var paralaxFX = true
    var newGame = true
    
    
    
//    enum CodingKeys: String, CodingKey {
//        case music, soundFX, paralaxFX, newGame
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(music, forKey: .music)
//        try container.encode(soundFX, forKey: .soundFX)
//        try container.encode(paralaxFX, forKey: .paralaxFX)
//        try container.encode(newGame, forKey: .newGame)
//    }
//
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        music = try container.decode(Bool.self, forKey: .music)
//        soundFX = try container.decode(Bool.self, forKey: .soundFX)
//        paralaxFX = try container.decode(Bool.self, forKey: .paralaxFX)
//        newGame = try container.decode(Bool.self, forKey: .newGame)
//    }
}
