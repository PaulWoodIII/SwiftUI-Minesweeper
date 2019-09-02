//
//  DifficultyLevel.swift
//  MinesweeperGameplay
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

public enum DifficultyLevel: Int, CaseIterable, Identifiable {
  
  case easy = 0
  case medium = 1
  case hard = 2
  
  public var displayString: String {
    switch self {
    case .easy:
      return "Easy"
    case .medium:
      return "Medium"
    case .hard:
      return "Hard"
    }
  }
  
  public var minedPercentage: Double {
    switch self {
    case .easy:
      return 0.15
    case .medium:
      return 0.20
    case .hard:
      return 0.25
    }
  }
  
  public var id: Int {
    return self.rawValue
  }
}
