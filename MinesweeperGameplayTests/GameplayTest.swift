//
//  GameplayTest.swift
//  MinesweeperGameplayTests
//
//  Created by Paul Wood on 9/1/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import XCTest
@testable import MinesweeperGameplay

class GameplayTest: XCTestCase {
  
  func testBuildBoard() {
    let minesweeper = Minesweeper()
    XCTAssertEqual(minesweeper.rows, 10)
    XCTAssertEqual(minesweeper.cols, 10)
    XCTAssertEqual(minesweeper.flagMode, false)
    XCTAssertEqual(minesweeper.flaggedCount, 0)
    XCTAssertEqual(minesweeper.gameState, .playing)
    XCTAssertEqual(minesweeper.difficultyLevel, .easy)
    
    var idx = 0
    minesweeper.board.forEach { square in
      
      XCTAssertFalse(square.flagged, "Square at idx: \(idx) is flagged?")
      //XCTAssertFalse(square.isMined,"Square at idx: \(idx) is mined?")
      idx += 1
    }
  }
  

  
  func testRevealSquare() {
    let minesweeper = Minesweeper(3, 3)
    var board = Board(3,3)
    board = board.setMines([3])
    minesweeper.board = board
    
    var square: Square!
    
    let expected =
      [
        [1,1,0],
        [9,1,0],
        [1,1,0],
      ]
    
    square = minesweeper.board[2,2]
    minesweeper.onSelect(square)
    XCTAssertTrue(minesweeper.board[2,0].isRevealed)
    XCTAssertTrue(minesweeper.board[2,1].isRevealed)
    XCTAssertTrue(minesweeper.board[2,2].isRevealed)
    
    minesweeper.toggleFlagMode()
    square = minesweeper.board[0,0]
    minesweeper.onSelect(square)
    XCTAssertTrue(minesweeper.board[0,0].flagged)
    square = minesweeper.board[0,0]
    minesweeper.onSelect(square)
    XCTAssertFalse(minesweeper.board[0,0].flagged)

    square = minesweeper.board[0,1]
    print(Point.index(forPoint: Point(x: 0, y: 1), rows: 3, cols: 3))
    minesweeper.onSelect(square)
    XCTAssertTrue(minesweeper.board[0,1].isMined)
    XCTAssertFalse(minesweeper.board[0,1].isRevealed)
    XCTAssertEqual(minesweeper.gameState, .won)

  }
  
}
