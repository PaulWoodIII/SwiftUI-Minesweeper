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
  
  @ObservedObject var minesweeper: Minesweeper = {
    let m = Minesweeper()
    m.board.setMines(10)
    m.board.setAdjacents()
    return m
  }()
  
  var body: some View {
    NavigationView{
      MineSweeperView(minesweeper: minesweeper)
      .navigationBarTitle("Mine Sweeper")
      .navigationBarItems(trailing:
        NavigationLink(destination: SettingsView(minesweeper: minesweeper)){
          VStack {
            Image(systemName: "gear")
            Text("Settings").font(.caption)
          }
        }
      )
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct MineSweeperView: View {
  
  @ObservedObject var minesweeper: Minesweeper
    
  var Minefield: some View { GeometryReader { proxy in
      ScrollView([.horizontal, .vertical], showsIndicators: true) {
        VStack(spacing:1.0) {
          ForEach((0...self.minesweeper.board.rows - 1), id: \.self) { row in
            HStack(spacing:1.0) {
              ForEach((0...self.minesweeper.board.cols - 1), id: \.self) { col in
                self.minesweeperCell(self.minesweeper.board[row,col], forSize: proxy.size)
              }
            }
          }
        }
      }
    }.layoutPriority(1)
  }
  
  var flagButton: some View {
    Button(action: minesweeper.toggleFlagMode) {
      Image(systemName: minesweeper.flagMode ? "flag.fill" : "flag")
        .font(.largeTitle)
        .foregroundColor(Color.accentColor)
        .padding(40)
        .background(
          Circle().foregroundColor(Color.accentColor.opacity(0.5))
      
      )
    }
  }

  var actions: some View {
    HStack {
      Text("Mines: \( max(0, (minesweeper.mines - minesweeper.flaggedCount)))")
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
      .background(
        Rectangle()
          .foregroundColor(Color.accentColor.opacity(0.2))
          .edgesIgnoringSafeArea(.bottom)
        
    )
  }
  
  var body: some View {


    VStack {
      
      Minefield

      if minesweeper.allowFlags {
        flagButton
      }
      
      Spacer()
      
      if !minesweeper.canPlay {
        HStack{
          Text("\(minesweeper.finishedReason)")
            .font(.title)
        }
      }
      actions
    }
  }
  
  let cellsPerRow: Int = 10
  fileprivate func minesweeperCell(_ square: Square, forSize size: CGSize) -> some View {
    return ZStack {
      Rectangle()
        .frame(width: size.width/CGFloat(cellsPerRow), height: size.width/CGFloat(cellsPerRow), alignment: .center)
        .foregroundColor(self.color(square: square))
        .aspectRatio(1.0, contentMode: .fit)
        .onTapGesture {
          self.minesweeper.onSelect(square)
      }
      if square.isRevealed {
          if square.isMined {
            //Text("\(square.isMined ? "M" : String(square.adjacent))")
            //Text("M")
          }
          Text("\(square.adjacent)")
            .foregroundColor(Color.colorForAdjacentCount(square.adjacent))
      }
      
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

struct MineSweeperView_Previews: PreviewProvider {
  static var previews: some View {
    MineSweeperContainer()
  }
}
