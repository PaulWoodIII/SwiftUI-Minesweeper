//
//  Minesweeper.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation
import Combine

public class Minesweeper: ObservableObject {
  
  @Published public var board = Board()
  @Published public var update: Int = 0
  
  public var boardStream: AnyPublisher<Board, Never> {
    get {
      return self.$board.share().eraseToAnyPublisher()
    }
  }
  
  public private(set) var rows: Int = 10 {
    didSet {
      resize()
    }
  }
  public private(set) var cols: Int = 10 {
    didSet {
      resize()
    }
  }
  
  public var rng = SystemRandomNumberGenerator()
  
  public private(set) var mines: Int = 10
  public private(set) var flaggedCount: Int = 0
  public private(set) var flagMode: Bool = false
  public private(set) var gameState: GameState = .playing
  public var difficultyLevel: DifficultyLevel = .easy {
    didSet{
      resize()
    }
  }
  
  public var allowFlags: Bool  = true {
    didSet {
      update += 1
    }
  }
  
  public var canPlay: Bool {
    switch gameState {
    case .playing:
      return true
    default:
      return false
    }
  }
  
  public var finishedReason: String {
    switch gameState {
    case .lost(_):
      return "You Lose"
    case .won:
      return "You Win"
    default:
      return ""
    }
  }
  
  public init(_ rows: Int = 10, _ cols: Int = 10) {
    self.rows = rows
    self.cols = cols
    resize()
    self.board = Board(rows, cols)
    createMines()
  }
  
  public func toggleFlagMode() {
    if !canPlay {
      return
    }
    update += 1
    flagMode.toggle()
  }
  
  public func onSelect(row: Int, col: Int){
    self.onSelect(self.board[row, col])
  }
  
  public func onSelect(_ square: Square) {
    if !canPlay {
      return
    }
    var next = self.board[square.x, square.y]
    if flagMode {
      next.flagged.toggle()
      if next.flagged {
        flaggedCount += 1
      } else {
        flaggedCount -= 1
      }
    } else {
      if next.flagged {
        //skip
      } else if next.isMined {
        next.isRevealed = true
        gameState = .lost(square)
      } else if next.adjacent == 0 {
        next.isRevealed = true
        reveal(from: square)
      } else {
        next.isRevealed = true
      }
    }
    self.board[square.x, square.y] = next
    checkForFlagWin()
    checkForClickedAllWin()
  }
  
  public func resize() {
    self.mines = Int(Double(rows * cols) * self.difficultyLevel.minedPercentage)
    reset()
  }
  
  public func reset() {
    gameState = .playing
    flaggedCount = 0
    flagMode = false
    self.board = Board(rows, cols)
    createMines()
  }
  
  private func checkForFlagWin() {
    var minesFlaggedCorrectly: Int = 0
    var minesFlaggedIncorrectly: Int = 0
    for square in board {
      if square.isMined && square.flagged  {
        minesFlaggedCorrectly += 1
      }
      if square.flagged && !square.isMined {
        minesFlaggedIncorrectly += 1
      }
    }
    if minesFlaggedCorrectly == mines && minesFlaggedIncorrectly == 0 {
      self.gameState = .won
    }
  }
  
  private func checkForClickedAllWin() {
    var correctCount = 0
    for square in board {
      if (square.isRevealed || square.flagged) && !square.isMined {
        correctCount += 1
      }
    }
    if correctCount == rows * cols - mines {
      self.gameState = .won
    }
  }
  
  private func reveal(from: Square) {
    var queue = [from]
    var visited = Set<Point>()
    while queue.first != nil {
      let next = queue.first!
      let adjacents = Point.adjacents(next.point)
      adjacents.forEach { (toUpdate) in
        if toUpdate.x >= 0 && toUpdate.x < rows &&
          toUpdate.y >= 0 && toUpdate.y < cols {
          var square = board[toUpdate.x, toUpdate.y]
          if !visited.contains(square.point) {
            visited.insert(square.point)
            square.isRevealed = true
            if square.flagged == true {
              square.flagged = false
            }
            board[toUpdate.x, toUpdate.y] = square
            if square.adjacent == 0 {
              queue.append(square)
            }
          }
        }
      }
      queue.removeFirst()
    }
  }
  
  /// Array of Mine Locations
  public func createMines() {
    var randomSelection = Array<Bool>(repeating: false, count: rows*cols - mines)
    randomSelection += Array<Bool>(repeating: true, count: mines)
    randomSelection.shuffle(using: &rng)
    let randomIndexes: [Int] = randomSelection.enumerated().compactMap{ (index, hasMine) in
      if hasMine {
        return index
      }
      return nil
    }
    self.board = board.setMines(randomIndexes)
  }
}

public enum Reveal {
  case unknown
  case flagged
}

public enum GameState: Equatable {
  case playing
  case won
  case lost(_ square: Square)
}

#if canImport(SwiftUI)
import SwiftUI

public extension Minesweeper {
  var toggleFlagModeBinding: Binding<Bool> {
    return Binding<Bool>(get: {
      return self.flagMode
    }, set: { (nextValue) in
      self.flagMode = nextValue
    })
  }
  
  var rowCount: Binding<Int> {
    return Binding<Int>(get: {
      return self.rows
    }, set: {
      self.rows = $0
    })
  }
  
  var colCount: Binding<Int> {
    return Binding<Int>(get: {
      return self.cols
    }, set: {
      self.cols = $0
    })
  }
  
  var difficultyLevelBinding: Binding<Int> {
    return Binding<Int>( get: {
      return self.difficultyLevel.rawValue
    }, set: { nextValue in
      self.difficultyLevel = DifficultyLevel(rawValue: nextValue) ?? .easy
    })
  }
  
  var allowFlagsBinding: Binding<Bool> {
    return Binding<Bool> ( get: {
      return self.allowFlags
    }, set: { nextValue in
      self.allowFlags = nextValue
    })
  }
}
#endif
