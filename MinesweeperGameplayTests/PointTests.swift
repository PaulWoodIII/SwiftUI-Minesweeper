//
//  PointTests.swift
//  MinesweeperGameplayTests
//
//  Created by Paul Wood on 9/1/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import XCTest
@testable import MinesweeperGameplay

class PointTests: XCTestCase {
  
  func testAdjacents() {
    let zeroAdjacents: Set<Point> = Set( Point.adjacents(Point(x: 0, y: 0)))
    let expected: Set<Point> = Set<Point>( [
      Point(x: -1, y: -1),
      Point(x: 0, y: -1),
      Point(x: 1, y: -1),
      Point(x: -1, y: 0),
      Point(x: 1, y: 0),
      Point(x: -1, y: 1),
      Point(x: 0, y: 1),
      Point(x: 1, y: 1),
    ])
    XCTAssertEqual(zeroAdjacents, expected, "Correct: \(zeroAdjacents.union(expected)), \n Incorrect: \(zeroAdjacents.symmetricDifference(expected))")
  }
  
  func testPointToMatrixArithmetic() {
    let rows = 5
    let cols = 3
    let testMatrix = [
    [ 0, 1, 2],
    [ 3, 4, 5],
    [ 6, 7, 8],
    [ 9,10,11],
    [12,13,14]
    ]
    for y in 0...rows - 1 {
      for x in 0...cols - 1 {
        let point = Point(x: x, y: y)
        XCTAssertEqual(Point.point(forIndex: testMatrix[y][x], rows: rows, cols: cols), point)
      }
    }
    
    XCTAssertEqual( Point.point(forIndex: 0, rows: 3, cols: 3), Point(x: 0, y: 0))
    XCTAssertEqual( Point.point(forIndex: 1, rows: 3, cols: 3), Point(x: 1, y: 0))
    XCTAssertEqual( Point.point(forIndex: 1, rows: 3, cols: 3), Point(x: 1, y: 0))
  }
  
  func testIndexToPointArithmetic() {
    
    XCTAssertEqual( Point.index(forPoint: Point(x: 0, y: 0), rows: 3, cols: 3), 0)
    XCTAssertEqual( Point.index(forPoint: Point(x: 1, y: 0), rows: 3, cols: 3), 1)
    XCTAssertEqual( Point.index(forPoint: Point(x: 2, y: 0), rows: 3, cols: 3), 2)
    XCTAssertEqual( Point.index(forPoint: Point(x: 0, y: 1), rows: 3, cols: 3), 3)
    XCTAssertEqual( Point.index(forPoint: Point(x: 1, y: 1), rows: 3, cols: 3), 4)
  }
}
