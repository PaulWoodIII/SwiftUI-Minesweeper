//
//  MinesweeperCell.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import MinesweeperGameplay

struct MinesweeperCell: View {
  
  var square: Square
  var size: CGSize
  var onSelect: ((Square) -> ())
  let cellsPerRow: Int = 10
  
  var body : some View {
    ZStack {
      Rectangle()
        .aspectRatio(1.0, contentMode: .fit)
        .frame(minWidth: 20, idealWidth: 44, maxWidth: 44, minHeight: 20, idealHeight: 44, maxHeight: 44, alignment: .center)
        //.frame(width: size.width/CGFloat(cellsPerRow), height: size.width/CGFloat(cellsPerRow), alignment: .center)
        .foregroundColor(color(square: square))
        .aspectRatio(1.0, contentMode: .fit)
        
      if square.isRevealed {
        if square.isMined {

        }
        Text("\(square.adjacent)")
          .foregroundColor(Color.colorForAdjacentCount(square.adjacent))
      }
      
      if square.flagged {
        Image(systemName:"flag")
      }
      
    }.onTapGesture {
        self.onSelect(self.square)
    }.layoutPriority(1)
  }
  
  func color(square: Square) -> Color {
    if square.flagged {
      return Color.yellow
    }
    if square.isRevealed {
      if square.isMined {
        return Color.red
      } else {
        return Color.gray.opacity(0.5)
      }
    }
    return Color.gray
  }
}

struct MinesweeperCell_Previews: PreviewProvider {
    static var previews: some View {
      MinesweeperCell(square: Square(x: 1, y: 1,
                                     isMined: false,
                                     isRevealed: true,
                                     flagged: false,
                                     isSelected: false,
                                     adjacent: 1),
                      size: CGSize(width: 200,height: 200),
                      onSelect: { square in
                        
      })
    }
}
