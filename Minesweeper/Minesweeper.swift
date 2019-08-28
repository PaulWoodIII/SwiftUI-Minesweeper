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
  
  @Published var board = Board()
  
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
  public private(set) var mines: Int = 10
  public private(set) var flaggedCount: Int = 0
  public private(set) var flagMode: Bool = false
  public private(set) var gameState: GameState = .playing
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
  
  public func onSelect(_ square: Square) {
    var next = self.board[square.x, square.y]
    if flagMode {
      next.flagged.toggle()
      flaggedCount += 1
    } else {
      next.isRevealed = true
      if next.isMined {
        gameState = .lost(square)
      } else if next.adjacent == 0 {
        reveal(from: square)
      }
    }
    if flaggedCount == mines {
      checkForWin()
    }
    self.board[square.x, square.y] = next
  }
  
  public func resize() {
    self.mines = Int(Double(rows * cols) * 0.15)
    reset()
  }
  
  public func reset() {
    gameState = .playing
    flaggedCount = 0
    flagMode = false
    board = Board(board.rows, board.cols)
    board.setMines(mines)
    board.setAdjacents()
  }
  
  private func checkForWin() {
    var minesFlaggedCorrectly: Int = 0
    for square in board {
      if square.isMined && square.flagged  {
        minesFlaggedCorrectly += 1
      }
    }
    if minesFlaggedCorrectly == mines {
      self.gameState = .won
    }
  }
  
  private func reveal(from: Square) {
    var queue = [from]
    var visited = Set<Square>()
    while queue.first != nil {
      let next = queue.first!
      let adjacents = Board.adjacents(next.coordinates)
      adjacents.forEach { (toUpdate) in
        if toUpdate.0 >= 0 && toUpdate.0 < rows &&
          toUpdate.1 >= 0 && toUpdate.1 < cols {
          var square = board[toUpdate.0, toUpdate.1]
          if !visited.contains(square) {
            visited.insert(square)
            square.isRevealed = true
            board[toUpdate.0, toUpdate.1] = square
            if square.adjacent == 0 {
              queue.append(square)
            }
          }
        }
      }
      queue.removeFirst()
    }
  }
  
  public init(_ rows: Int = 10, _ cols: Int = 10) {
    self.rows = rows
    self.cols = cols
    self.board = Board(rows,cols)
  }
}

public struct Board: Sequence {
  private var squares: [Square]
  var rows: Int
  var cols: Int
  init(_ rows: Int = 10, _ cols: Int = 10) {
    self.rows = rows
    self.cols = cols
    self.squares = Array<Bool>(repeating: true, count: rows*cols).enumerated().map({ arg1 -> Square in
      let (i,_) = arg1
      let c = Board.coordinate(forIndex: i, rows: rows, cols: cols)
      return Square(x: c.0, y: c.1)
    })
  }
  
  public func makeIterator() -> IndexingIterator<[Square]> {
    return squares.makeIterator()
  }
  
  mutating func setMines(_ minecount: Int) {
    var randomSelection = Array<Bool>(repeating: false, count: rows*cols - minecount )
    randomSelection += Array<Bool>(repeating: true, count: minecount)
    randomSelection.shuffle()
    randomSelection.enumerated().forEach { (i, hasMine) in
      if hasMine {
        var square = squares[i]
        square.isMined = true
        squares[i] = square
      }
    }
  }
  
  mutating func setAdjacents() {
    let mines = self.squares.enumerated().reduce(into: [Int]()) { (result, arg1) in
      let (i, square) = arg1
      if square.isMined {
        result.append(i)
      }
    }
    mines.forEach { i in
      let coordinates = coordinate(forIndex: i)
      let adjacents = Board.adjacents(coordinates)
      adjacents.forEach { (toUpdate) in
        if toUpdate.0 >= 0 && toUpdate.0 < rows &&
          toUpdate.1 >= 0 && toUpdate.1 < cols {
          var square = self[toUpdate.0, toUpdate.1]
          square.adjacent += 1
          self[toUpdate.0, toUpdate.1] = square
        }
      }
    }
  }
  
  public static func adjacents(_ coordinates: (Int, Int)) -> [(Int, Int)] {
    let leadingTop = (coordinates.0 - 1, coordinates.1 - 1)
    let top = (coordinates.0, coordinates.1 - 1)
    let trailingTop = (coordinates.0 + 1, coordinates.1 - 1)
    let leading = (coordinates.0 - 1, coordinates.1)
    let trailing = (coordinates.0 + 1, coordinates.1)
    let leadingBottom = (coordinates.0 - 1, coordinates.1 + 1)
    let bottom = (coordinates.0, coordinates.1 + 1)
    let trailingBottom = (coordinates.0 + 1, coordinates.1 + 1)
    return [leadingTop, top, trailingTop, leading, trailing, leadingBottom, bottom, trailingBottom]
  }
  
  public static func adjacentsCompass(_ coordinates: (Int, Int)) -> [(Int, Int)] {
    let top = (coordinates.0, coordinates.1 - 1)
    let leading = (coordinates.0 - 1, coordinates.1)
    let trailing = (coordinates.0 + 1, coordinates.1)
    let bottom = (coordinates.0, coordinates.1 + 1)
    return [top, leading, trailing, bottom]
  }
  
  public static func coordinate(forIndex idx: Int, rows: Int, cols: Int) -> (Int, Int) {
    precondition(idx < rows * cols)
    return (idx / rows, idx % rows)
  }
  
  public func coordinate(forIndex idx: Int) -> (Int, Int) {
    return Board.coordinate(forIndex: idx, rows: self.rows, cols: self.cols)
  }
  
  subscript(x: Int, y: Int) -> Square {
    get {
      return squares[cols * x + y]
    }
    set {
      squares[cols * x + y] = newValue
    }
  }
}

public struct Square: Identifiable, Equatable, Hashable {
  let x: Int
  let y: Int
  var isMined: Bool = false
  var isRevealed: Bool = false
  var flagged: Bool = false
  var isSelected: Bool = false
  var adjacent: Int = 0
  
  var coordinates: (Int, Int) {
    return (x,y)
  }
  
  public var id: Int {
    return x*y
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
  
  public static func == (lhs: Square, rhs: Square) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
}

public enum Reveal {
  case unknown
  case flagged
}

public enum GameState {
  case playing
  case won
  case lost(_ square: Square)
}

import SwiftUI

extension Minesweeper {
  var toggleFlagMode: Binding<Bool> {
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
}
