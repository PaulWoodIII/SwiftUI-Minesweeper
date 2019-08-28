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
    }
  }
}

struct MineSweeperView: View {
  
  @ObservedObject var minesweeper: Minesweeper = {
    let m = Minesweeper()
    m.board.setMines(10)
    m.board.setAdjacents()
    return m
  }()
  
  fileprivate func minesweeperCell(_ square: Square) -> some View {
    return ZStack {
      RoundedRectangle(cornerRadius: 3)
        .foregroundColor(self.color(square: square))
        .aspectRatio(1.0, contentMode: .fit)
        .onTapGesture {
          self.minesweeper.onSelect(square)
      }
      if square.isRevealed {
          if square.isMined {
              //Text("\(square.isMined ? "M" : String(square.adjacent))")
            Text("M")
          }
          Text("\(square.adjacent)")
            .foregroundColor(colorForAdjacentCount(square.adjacent))
      }
      
    }.layoutPriority(1)
  }
  
  var body: some View {
    VStack {
      ForEach((0...minesweeper.board.rows - 1), id: \.self) { row in
        HStack {
          ForEach((0...self.minesweeper.board.cols - 1), id: \.self) { col in
            self.minesweeperCell(self.minesweeper.board[row,col])
          }
        }
      }
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
  
  func colorForAdjacentCount(_ count: Int) -> Color {
    switch count {
    case 1:
      return Color.blue
    case 2:
      return Color.green
    case 3:
      return Color.red
    case 4:
      return Color(hue: 209.0, saturation: 56.0, brightness: 26.0)
    case 5:
      return Color(hue: 353.0, saturation: 24.0, brightness: 26.0)
    case 6:
      return Color(hue: 176.0, saturation: 70.0, brightness: 100.0)
    case 7:
      return Color.black
    default:
      return Color.gray
    }
  }
}

struct MineSweeperView_Previews: PreviewProvider {
  static var previews: some View {
    MineSweeperView(minesweeper: Minesweeper())
  }
}
