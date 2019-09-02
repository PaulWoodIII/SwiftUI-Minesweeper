//
//  GameNotifications.swift
//  MinesweeperGameplay
//
//  Created by Paul Wood on 9/2/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

public extension Notification.Name {
  static let click = Notification.Name(rawValue: "Gameplay.Notification.Clicked")
  static let flagOn = Notification.Name(rawValue: "Gameplay.Notification.FlagOn")
  static let flagOff = Notification.Name(rawValue: "Gameplay.Notification.FlagOff")
  static let win = Notification.Name(rawValue: "Gameplay.Notification.Win")
  static let lose = Notification.Name(rawValue: "Gameplay.Notification.Lose")
  static let restart = Notification.Name(rawValue: "Gameplay.Notification.Restart")
}
