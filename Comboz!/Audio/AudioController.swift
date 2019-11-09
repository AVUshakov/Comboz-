//
//  AudioFile.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 28/02/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {
    
    static let sharedController = AudioController()
    
    var backgroundMusic : AVAudioPlayer!
    var fx : AVAudioPlayer!
    
    var viewController = String()
    
    func playBackgroundMusic(file: String) {
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: file, withExtension: "mp3")!)
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.play()
        } catch {
            print("Can't play music")
        }
    }
    
    func playFXSound(file: String) {
        do {
            fx = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: file, withExtension: "mp3")!)
            fx.play()
        } catch {
            print("Can't play sound")
        }
    }
    
    enum SoundFile: String {
        case tapIn = "tapInSound"
        case tapOut = "tapOutSound"
        case tapOnCard = "tapOnCardSound"
        case tapDealCard = "dealCardSound"
        case matchingComboz = "matchingComboz"
        case dismathingComboz = "dismatchingComboz"
        case timeBonus = "timeBonusSound"
        case dealCards = "dealCards"
        case menuMusic = "comboz"
    }
}
