//
//  Point.swift
//  MinesweeperGameplay
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

public struct Point: Hashable {
  public var x: Int, y: Int
}

public extension Point {
  
  var adjacents: [Point] {
    return Point.adjacents(self)
  }

  static func adjacents(_ coordinates: Point) -> [Point] {
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
  
  static func point(forIndex idx: Int, rows: Int, cols: Int) -> Point {
    precondition(idx < rows * cols)
    return Point(x: idx % cols, y: idx / cols)
  }
  
  static func index(forPoint point: Point, rows: Int, cols: Int) -> Int {
    precondition(point.x * point.y < rows * cols)
    return point.y * cols + point.x
  }
}
