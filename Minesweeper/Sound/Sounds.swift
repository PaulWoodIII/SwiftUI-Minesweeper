//
//  Sounds.swift
//
//  Created by Paul Wood on 9/2/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import MinesweeperGameplay

class Sounds: NSObject {
  
  var cancelBag: Set<AnyCancellable> = []
  
  private struct NameFunction {
    let name: Notification.Name
    let function: Selector
  }
  
  private let sinkMappings: [NameFunction] = {
    return [
      NameFunction(name: Notification.Name.click,   function: #selector(didClickEmpty)),
      NameFunction(name: Notification.Name.flagOn,  function: #selector(didFlagOn)),
      NameFunction(name: Notification.Name.flagOff, function: #selector(didFlagOff)),
      NameFunction(name: Notification.Name.win,     function: #selector(didWin)),
      NameFunction(name: Notification.Name.lose,    function: #selector(didLose)),
      NameFunction(name: Notification.Name.restart, function: #selector(didRestart)),
    ]
  }()
  
  override init() {
    super.init()
    sinkMappings.forEach { (mapping: Sounds.NameFunction) in
      self.cancelBag.insert(
        NotificationCenter.default.publisher(for: mapping.name).sink(receiveValue: { _ in
          self.perform(mapping.function)
        })
      )
    }
  }
    
  var player: AVAudioPlayer?
  
  @objc func didClickEmpty() {
    playSound("click")
  }
  
  @objc func didFlagOn() {
    playSound("flag")
  }
  
  @objc func didFlagOff() {
    playSound("flag")
  }
  
  @objc func didWin() {
    playSound("win")
  }
  
  @objc func didLose() {
    playSound("lose")
  }
  
  @objc func didRestart() {
    playSound("restart")
  }
  
  func playSound(_ name: String = "click") {
      guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

      do {
          try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
          try AVAudioSession.sharedInstance().setActive(true)

          /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
          player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

          guard let player = player else { return }

          player.play()

      } catch let error {
          print(error.localizedDescription)
      }
  }
}
