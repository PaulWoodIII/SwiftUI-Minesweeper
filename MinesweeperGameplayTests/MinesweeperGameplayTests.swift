//
//  MinesweeperGameplayTests.swift
//  MinesweeperGameplayTests
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import XCTest
@testable import MinesweeperGameplay

class MinesweeperGameplayTests: XCTestCase {
  
  
  func testCoordinateMath() {
    let board = Board(10,10)
    let coordinate = board.coordinate(forIndex: 1)
    XCTAssertEqual(coordinate.x, 0)
    XCTAssertEqual(coordinate.y, 1)
  }
  
  func test1Example() {
    var board = Board(3, 3)
    var s = board[1,1]
    s.isMined = true
    board[1,1] = s
    board.setAdjacents()
    XCTAssertEqual(board[0,0].adjacent, 1)
    XCTAssertEqual(board[0,1].adjacent, 1)
    XCTAssertEqual(board[0,2].adjacent, 1)
    XCTAssertEqual(board[1,0].adjacent, 1)
    XCTAssertEqual(board[1,2].adjacent, 1)
    XCTAssertEqual(board[2,0].adjacent, 1)
    XCTAssertEqual(board[2,1].adjacent, 1)
    XCTAssertEqual(board[2,2].adjacent, 1)
  }
  
  func test3Example() {
    var board = Board(3, 3)
    var s = board[0,0]
    s.isMined = true
    board[0,0] = s
    
    s = board[2,2]
    s.isMined = true
    board[2,2] = s
    
    
    let expected =
      [
        [0,1,0],
        [1,2,1],
        [0,1,0],
    ]
    
    board.setAdjacents()
    
    for x in 0...2 {
      for y in 0...2 {
        XCTAssertEqual(board[x,y].adjacent, expected[x][y])
      }
    }
  }
  
  func test4Example() {
    var board = Board(4, 4)
    var s = board[0,0]
    s.isMined = true
    board[0,0] = s
    
    s = board[3,3]
    s.isMined = true
    board[3,3] = s
    
    
    let expected =
      [
        [0,1,0,0],
        [1,1,0,0],
        [0,0,1,1],
        [0,0,1,0],
    ]
    
    board.setAdjacents()
    
    for x in 0...3 {
      for y in 0...3 {
        XCTAssertEqual(board[x,y].adjacent, expected[x][y])
      }
    }
  }
  
  func test10Example() {
    let size = 10
    var board = Board(size, size)
    var s = board[0,0]
    s.isMined = true
    board[0,0] = s
    
    s = board[0,1]
    s.isMined = true
    board[0,1] = s
    
    s = board[4,4]
    s.isMined = true
    board[4,4] = s
    
    s = board[9,9]
    s.isMined = true
    board[9,9] = s
    
    let expected =
      [
        [1,1,1,0,0,0,0,0,0,0],
        [2,2,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0],
        [0,0,0,1,1,1,0,0,0,0],
        [0,0,0,1,0,1,0,0,0,0],
        [0,0,0,1,1,1,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,0,0,1,0],
    ]
    
    board.setAdjacents()
    
    for x in 0...size - 1 {
      for y in 0...size - 1 {
        XCTAssertEqual(board[x,y].adjacent, expected[x][y], "Error at: (x:\(x),y:\(y)")
      }
    }
  }
  
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      let m1 = Minesweeper()
      m1.board.setMines(100)
      let m2 = Minesweeper(100, 100)
      m2.board.setMines(100)
      // Put the code you want to measure the time of here.
    }
  }
  
  
}
