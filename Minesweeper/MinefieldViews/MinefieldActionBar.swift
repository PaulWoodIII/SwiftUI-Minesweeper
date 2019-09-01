//
//  MinefieldActionBar.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import MinesweeperGameplay

struct MinefieldActionBar: View {
  
  @ObservedObject var minesweeper: Minesweeper

  var body: some View {
    HStack {
      Text("Mines: \( max(0, (minesweeper.mines - minesweeper.flaggedCount)))")
       Spacer()
       if minesweeper.allowFlags {
        FlagButton(flagMode: minesweeper.flagMode,
                   action: minesweeper.toggleFlagMode)
       }
       Spacer()
       Button(action: minesweeper.reset) {
         Text("Reset")
           .foregroundColor(Color.accentColor)
           .padding()
           .background(
             RoundedRectangle(cornerRadius: 8)
               .foregroundColor(Color.accentColor.opacity(0.5))
         )
      }
    }.padding()
  }
}

struct MinefieldActionBar_Previews: PreviewProvider {
    static var previews: some View {
      MinefieldActionBar(minesweeper: Minesweeper())
    }
}
