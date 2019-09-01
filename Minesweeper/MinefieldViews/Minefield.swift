//
//  Minefield.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import MinesweeperGameplay

struct Minefield: View {
  
  @ObservedObject var minesweeper: Minesweeper
  
  var body: some View {
    GeometryReader { proxy in
      ScrollView([.horizontal, .vertical], showsIndicators: true) {
        VStack(spacing:1.0) {
          ForEach((0...self.minesweeper.board.rows - 1), id: \.self) { row in
            HStack(spacing:1.0) {
              ForEach((0...self.minesweeper.board.cols - 1), id: \.self) { col in
                MinesweeperCell(square: self.minesweeper.board[row,col],
                                size: proxy.size,
                                onSelect:self.minesweeper.onSelect(_:))
              }
            }
          }
        }
      }
    }
  }
}


struct Minefield_Previews: PreviewProvider {
    static var previews: some View {
      Minefield(minesweeper: Minesweeper())
    }
}
