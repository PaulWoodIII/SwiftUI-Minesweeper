//
//  BoardTests.swift
//  MinesweeperGameplayTests
//
//  Created by Paul Wood on 9/1/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import XCTest
@testable import MinesweeperGameplay

class BoardTests: XCTestCase {
  
  func testCoordinateMath() {
    let board = Board(10,10)
    let coordinate = board.point(forIndex: 1)
    XCTAssertEqual(coordinate.x, 1)
    XCTAssertEqual(coordinate.y, 0)
  }

  func testDebugDescription() {
    var board = Board(3, 3)
    var s = board[1,1]
    s.isMined = true
    board[1,1] = s
    board = board.setAdjacents(board)
    let expected = """
[
  [1,1,1],
  [1,9,1],
  [1,1,1],
]
"""
    XCTAssertEqual(board.debugDescription, expected)
  }
  
  func testMiningBoard() {
    
    var board = Board(3,3)
    board = board.setMines([3])

    board.enumerated().forEach { idx, square in
      XCTAssertFalse(square.flagged, "Square at idx: \(idx) is flagged?")
      if idx == 3 {
        XCTAssertTrue(square.isMined, "Square at idx: \(idx) is not mined?")
        XCTAssertTrue(board[0,1].isMined)
      } else {
        XCTAssertFalse(square.isMined, "Square at idx: \(idx) is mined?")
      }
    }
  }
  
  func testTinyBoard() {
    var board = Board(3, 3)
    var s = board[0,1]
    s.isMined = true
    board[0,1] = s
    
    board = board.setAdjacents(board)
    
    let expected =
      [
        [1,1,0],
        [9,1,0],
        [1,1,0],
      ]
    
    test(board, expected: expected)
  }
  
  func testTinySetMines() {
    var board = Board(3, 3)
    let mines: [Int] = [3]
    board = board.setMines(mines)
    
    let expected =
      [
        [1,1,0],
        [9,1,0],
        [1,1,0],
      ]
    
    test(board, expected: expected)
  }
  
  func testTinyLongBoard() {
    var board = Board(6, 3)
    
    var s = board[1,1]
    s.isMined = true
    board[1,1] = s

    s = board[0,3]
    s.isMined = true
    board[0,3] = s

    board = board.setAdjacents(board)
    
    let expected =
      [
        [1,1,1],
        [1,9,1],
        [2,2,1],
        [9,1,0],
        [1,1,0],
        [0,0,0],
    ]
    
    test(board, expected: expected)
  }
  
  func test3x3() {
    var board = Board(3, 3)
    var s = board[0,0]
    s.isMined = true
    board[0,0] = s
    
    s = board[2,2]
    s.isMined = true
    board[2,2] = s
    
    board = board.setAdjacents(board)
    
    let expected =
      [
        [9,1,0],
        [1,2,1],
        [0,1,9],
    ]
    
    test(board, expected: expected)
  }
  
  func test4x4() {
    var board = Board(4, 4)
    var s = board[0,0]
    s.isMined = true
    board[0,0] = s
    
    s = board[3,3]
    s.isMined = true
    board[3,3] = s
    
    board = board.setAdjacents(board)
    
    let expected =
      [
        [9,1,0,0],
        [1,1,0,0],
        [0,0,1,1],
        [0,0,1,9],
    ]
    
    
    test(board, expected: expected)
  }
  
  func test10x10() {
    let size = 10
    var board = Board(size, size)
    
    //Top Left
    var s = board[0,0]
    s.isMined = true
    board[0,0] = s
    s = board[1,0]
    s.isMined = true
    board[1,0] = s

    //Top Right
    s = board[9,1]
    s.isMined = true
    board[9,1] = s
    
    s = board[4,4]
    s.isMined = true
    board[4,4] = s

    //Bottom Right Corner
    s = board[8,8]
    s.isMined = true
    board[8,8] = s
    s = board[9,9]
    s.isMined = true
    board[9,9] = s
    
    //Bottom Left Corner
  
    //Top
    s = board[0,7]
    s.isMined = true
    board[0,7] = s
    s = board[1,7]
    s.isMined = true
    board[1,7] = s
    s = board[2,7]
    s.isMined = true
    board[2,7] = s
    
    //Middle
    s = board[0,8]
    s.isMined = true
    board[0,8] = s
    s = board[2,8]
    s.isMined = true
    board[2,8] = s
    
    
    //Bottom
    s = board[0,9]
    s.isMined = true
    board[0,9] = s
    s = board[1,9]
    s.isMined = true
    board[1,9] = s
    s = board[2,9]
    s.isMined = true
    board[2,9] = s
    
    board = board.setAdjacents(board)
    
    let expected =
      [/*0,1,2,3,4,5,6,7,8,9     X axis */
/* 0 */ [9,9,1,0,0,0,0,0,1,1],
/* 1 */ [2,2,1,0,0,0,0,0,1,9],
/* 2 */ [0,0,0,0,0,0,0,0,1,1],
/* 3 */ [0,0,0,1,1,1,0,0,0,0],
/* 4 */ [0,0,0,1,9,1,0,0,0,0],
/* 5 */ [0,0,0,1,1,1,0,0,0,0],
/* 6 */ [2,3,2,1,0,0,0,0,0,0],
/* 7 */ [9,9,9,2,0,0,0,1,1,1],
/* 8 */ [9,8,9,3,0,0,0,1,9,2],
/* 9 */ [9,9,9,2,0,0,0,1,2,9],
/* Y Axis */
    ]
    
    test(board, expected: expected)
  }
  
  func test10x15Example() {
        var board = Board(15, 10)
        
        //Top Left
        var s = board[0,0]
        s.isMined = true
        board[0,0] = s
        s = board[1,0]
        s.isMined = true
        board[1,0] = s

        //Top Right
        s = board[9,1]
        s.isMined = true
        board[9,1] = s
        
        s = board[4,4]
        s.isMined = true
        board[4,4] = s

        //Bottom Right Corner
        s = board[8,8]
        s.isMined = true
        board[8,8] = s
        s = board[9,9]
        s.isMined = true
        board[9,9] = s
        
        //Bottom Left Corner
      
        //Top
        s = board[0,7]
        s.isMined = true
        board[0,7] = s
        s = board[1,7]
        s.isMined = true
        board[1,7] = s
        s = board[2,7]
        s.isMined = true
        board[2,7] = s
        
        //Middle
        s = board[0,8]
        s.isMined = true
        board[0,8] = s
        s = board[2,8]
        s.isMined = true
        board[2,8] = s
        
        
        //Bottom
        s = board[0,9]
        s.isMined = true
        board[0,9] = s
        s = board[1,9]
        s.isMined = true
        board[1,9] = s
        s = board[2,9]
        s.isMined = true
        board[2,9] = s
        
        board = board.setAdjacents(board)
        
        let expected =
          [/*0,1,2,3,4,5,6,7,8,9     X axis */
    /* 0 */ [9,9,1,0,0,0,0,0,1,1],
    /* 1 */ [2,2,1,0,0,0,0,0,1,9],
    /* 2 */ [0,0,0,0,0,0,0,0,1,1],
    /* 3 */ [0,0,0,1,1,1,0,0,0,0],
    /* 4 */ [0,0,0,1,9,1,0,0,0,0],
    /* 5 */ [0,0,0,1,1,1,0,0,0,0],
    /* 6 */ [2,3,2,1,0,0,0,0,0,0],
    /* 7 */ [9,9,9,2,0,0,0,1,1,1],
    /* 8 */ [9,8,9,3,0,0,0,1,9,2],
    /* 9 */ [9,9,9,2,0,0,0,1,2,9],
    /*10 */ [2,3,2,1,0,0,0,0,1,1],
    /*11 */ [0,0,0,0,0,0,0,0,0,0],
    /*12 */ [0,0,0,0,0,0,0,0,0,0],
    /*13 */ [0,0,0,0,0,0,0,0,0,0],
    /*14 */ [0,0,0,0,0,0,0,0,0,0],
    /* Y Axis */
        ]
        
        test(board, expected: expected)
  }
  
  func test(_ board: Board, expected: [[Int]]) {
    for y in 0...board.rows - 1 {
      for x in 0...board.cols - 1 {
        let s = board[x,y]
        if s.isMined {
          XCTAssertEqual(9,
                         expected[y][x], "\nError at: Point(x:\(x),y:\(y)) \n\n Board:\n\(board)")
        } else {
          XCTAssertEqual(s.adjacent,
                         expected[y][x], "\nError at: Point(x:\(x),y:\(y)) \n\n Board:\n\(board)")
        }
      }
    }
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      let m1 = Minesweeper()
      m1.board.setMines([1,10,20,30,40,50,60,70,80,90])
      // Put the code you want to measure the time of here.
    }
  }
  
}
