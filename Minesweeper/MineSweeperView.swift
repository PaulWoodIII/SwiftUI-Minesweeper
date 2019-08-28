//
//  ContentView.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import Combine

struct MineSweeperContainer: View {
  var body: some View {
    NavigationView{
      MineSweeperView()
      .navigationBarTitle("Mine Sweeper")
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct MineSweeperView: View {
  
  @ObservedObject var minesweeper: Minesweeper = {
    let m = Minesweeper()
    m.board.setMines(10)
    m.board.setAdjacents()
    return m
  }()
  
  var body: some View {
    VStack {
      
      GeometryReader { proxy in
        Minefield(dataSource: self.minesweeper, size: proxy.size)
      }.layoutPriority(1)
      
      Spacer()
      
      if !minesweeper.canPlay {
        HStack{
          Text("\(minesweeper.finishedReason)")
        }
      }
      HStack {
        Text("Mines: \( max(0, (minesweeper.mines - minesweeper.flaggedCount)))")
        Toggle(isOn: minesweeper.toggleFlagMode) {
          Text("Flag Mode")
        }
        Button(action: minesweeper.reset) {
          Text("Reset")
            .foregroundColor(Color.accentColor)
            .padding()
          .background(
            RoundedRectangle(cornerRadius: 8)
              .foregroundColor(Color.accentColor.opacity(0.5))
          )
        }
      }
    }.padding()
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

struct MineSweeperView_Previews: PreviewProvider {
  static var previews: some View {
    MineSweeperView(minesweeper: Minesweeper())
  }
}
