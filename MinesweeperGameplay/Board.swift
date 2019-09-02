//
//  Board.swift
//  MinesweeperGameplay
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

public struct Board: Sequence, Identifiable {
  private var squares: [Square]
  public var rows: Int
  public var cols: Int
  public var count: Int {
    return rows * cols
  }
  public var id: UUID = UUID()
  
  public init(_ rows: Int = 10, _ cols: Int = 10) {
    self.rows = rows
    self.cols = cols
    self.squares = Array<Bool>(repeating: true, count: rows*cols).enumerated().map({ arg1 -> Square in
      let (i,_) = arg1
      let c = Point.point(forIndex: i, rows: rows, cols: cols)
      return Square(x: c.x, y: c.y)
    })
  }
  
  public func makeIterator() -> IndexingIterator<[Square]> {
    return squares.makeIterator()
  }
  
  // Passed an array of Mine Locations
  public func setMines(_ mines: [Int]) -> Board {
    var nextBoard =  self
    mines.forEach { (index) in
      var square = nextBoard.squares[index]
      square.isMined = true
      nextBoard.squares[index] = square
    }
    nextBoard = setAdjacents(nextBoard)
    return nextBoard
  }
  
  public func setAdjacents(_ board: Board) -> Board {
    var nextBoard = board
    let mined: [Square] = nextBoard.squares.reduce(into: [Square]()) { (result, square) in
      if square.isMined {
        result.append(square)
      }
    }
    mined.forEach { square in
      let adjacents = square.point.adjacents
      adjacents.forEach { toUpdate in
        if toUpdate.x >= 0 && toUpdate.x < cols &&
          toUpdate.y >= 0 && toUpdate.y < rows {
          var square = nextBoard[toUpdate.x, toUpdate.y]
          square.adjacent += 1
          nextBoard[toUpdate.x, toUpdate.y] = square
        }
      }
    }
    return nextBoard
  }
  
  public func point(forIndex idx: Int) -> Point {
    return Point.point(forIndex: idx, rows: self.rows, cols: self.cols)
  }
  
  public subscript(x: Int, y: Int) -> Square {
    get {
      let index = Point.index(forPoint: Point(x: x, y: y), rows: self.rows, cols: self.cols)
      return squares[index]
    }
    set {
      let index = Point.index(forPoint: Point(x: x, y: y), rows: self.rows, cols: self.cols)
      squares[index] = newValue
    }
  }
}

extension Board: CustomDebugStringConvertible {
  public var debugDescription: String {
    get {
      var returnVal = "["
      for y in 0...self.rows - 1 {
        returnVal.append("\n  [")
        var returnRow = String()
        for x in 0...self.cols - 1 {
          let s = self[x,y]
          if s.isMined {
            returnRow.append("9")
          } else {
            returnRow.append("\(s.adjacent)")
          }
          if x < self.cols - 1 {
            returnRow.append(",")
          }
        }
        returnVal.append(returnRow)
        returnVal.append("],")
      }
      returnVal.append("\n]")
      return returnVal
    }
  }
}
