//
//  Square.swift
//  MinesweeperGameplay
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

public struct Square: Identifiable, Equatable, Hashable {
  public let x: Int
  public let y: Int
  public var isMined: Bool = false
  public var isRevealed: Bool = false
  public var flagged: Bool = false
  public var isSelected: Bool = false
  public var adjacent: Int = 0
  public var id: UUID = UUID()

  public init(
    x: Int,
    y: Int,
    isMined: Bool = false,
    isRevealed: Bool = false,
    flagged: Bool = false,
    isSelected: Bool = false,
    adjacent: Int = 0
  ) {
    self.x = x
    self.y = y
    self.isMined = isMined
    self.isRevealed = isRevealed
    self.flagged = flagged
    self.isSelected = isSelected
    self.adjacent = adjacent
  }
  
  public var point: Point {
    return Point(x: x,y: y)
  }
  
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
    hasher.combine(isMined)
    hasher.combine(isRevealed)
    hasher.combine(flagged)
    hasher.combine(isSelected)
    hasher.combine(adjacent)
  }
  
  public static func == (lhs: Square, rhs: Square) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
}
