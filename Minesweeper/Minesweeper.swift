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
  @Published var update: Int = 0
  var boardStream: AnyPublisher<Board, Never> {
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
  
  public func toggleFlagMode() {
    update += 1
    flagMode.toggle()
  }
  
  public func onSelect(row: Int, col: Int){
    self.onSelect(self.board[row, col])
  }
  
  public func onSelect(_ square: Square) {
    var next = self.board[square.x, square.y]
    if flagMode {
      next.flagged.toggle()
      if next.flagged {
        flaggedCount += 1
      } else {
        flaggedCount -= 1
      }
    } else {
      next.isRevealed = true
      if next.flagged {
        next.flagged = false
      }
      if next.isMined {
        gameState = .lost(square)
      } else if next.adjacent == 0 {
        reveal(from: square)
      }
    }
    self.board[square.x, square.y] = next
    checkForFlagWin()
    checkForClickedAllWin()
  }
  
  public func resize() {
    self.mines = Int(Double(rows * cols) * 0.15)
    reset()
  }
  
  public func reset() {
    gameState = .playing
    flaggedCount = 0
    flagMode = false
    var nextBoard = Board(board.rows, board.cols)
    nextBoard.setMines(mines)
    nextBoard.setAdjacents()
    self.board = nextBoard
  }
  
  private func checkForFlagWin() {
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
  
  private func checkForClickedAllWin() {
    var isRevealedCount = 0
    for square in board {
      if square.isRevealed {
        isRevealedCount += 1
      }
    }
    if isRevealedCount == rows * cols - mines {
      self.gameState = .won
    }
  }
  
  private func reveal(from: Square) {
    var queue = [from]
    var visited = Set<Point>()
    while queue.first != nil {
      let next = queue.first!
      let adjacents = Board.adjacents(next.point)
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
  
  public init(_ rows: Int = 40, _ cols: Int = 40) {
    self.rows = rows
    self.cols = cols
    self.board = Board(rows,cols)
  }
}

public struct Board: Sequence, Identifiable {
  private var squares: [Square]
  var rows: Int
  var cols: Int
  var count: Int {
    return rows * cols
  }
  public var id: UUID = UUID()
  
  init(_ rows: Int = 10, _ cols: Int = 10) {
    self.rows = rows
    self.cols = cols
    self.squares = Array<Bool>(repeating: true, count: rows*cols).enumerated().map({ arg1 -> Square in
      let (i,_) = arg1
      let c = Board.coordinate(forIndex: i, rows: rows, cols: cols)
      return Square(x: c.x, y: c.y)
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
        if toUpdate.x >= 0 && toUpdate.x < rows &&
          toUpdate.y >= 0 && toUpdate.y < cols {
          var square = self[toUpdate.x, toUpdate.y]
          square.adjacent += 1
          self[toUpdate.x, toUpdate.y] = square
        }
      }
    }
  }
  
  /// Actually Used
  public static func adjacents(_ coordinates: Point) -> [Point] {
    let leadingTop =     Point(x:coordinates.x - 1, y: coordinates.y - 1)
    let top =            Point(x:coordinates.x,     y: coordinates.y - 1)
    let trailingTop =    Point(x:coordinates.x + 1, y: coordinates.y - 1)
    let leading =        Point(x:coordinates.x - 1, y: coordinates.y    )
    let trailing =       Point(x:coordinates.x + 1, y: coordinates.y    )
    let leadingBottom =  Point(x:coordinates.x - 1, y: coordinates.y + 1)
    let bottom =         Point(x:coordinates.x,     y: coordinates.y + 1)
    let trailingBottom = Point(x:coordinates.x + 1, y: coordinates.y + 1)
    return [leadingTop, top, trailingTop, leading, trailing, leadingBottom, bottom, trailingBottom]
  }
  
  public static func coordinate(forIndex idx: Int, rows: Int, cols: Int) -> Point {
    precondition(idx < rows * cols)
    return Point(x: idx / rows, y: idx % rows)
  }
  
  public func coordinate(forIndex idx: Int) -> Point {
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

public struct Point: Hashable {
  var x: Int, y: Int
}

public struct Square: Identifiable, Equatable, Hashable {
  let x: Int
  let y: Int
  var isMined: Bool = false
  var isRevealed: Bool = false
  var flagged: Bool = false
  var isSelected: Bool = false
  var adjacent: Int = 0
  
  var point: Point {
    return Point(x: x,y: y)
  }
  
  public var id: UUID = UUID()
  
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
}
