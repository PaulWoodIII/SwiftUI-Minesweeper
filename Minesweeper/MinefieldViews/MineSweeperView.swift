//
//  ContentView.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/27/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import Combine
import MinesweeperGameplay

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
        .navigationBarTitle("Mine Sweeper", displayMode: .inline)
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
  
  var body: some View {
    VStack {
      Minefield(minesweeper: minesweeper).layoutPriority(1)
      if !minesweeper.canPlay {
        HStack{
          Text("\(minesweeper.finishedReason)")
            .font(.title)
        }
      }
      Divider()
      MinefieldActionBar(minesweeper: minesweeper)
    }
  }
}

struct MineSweeperView_Previews: PreviewProvider {
  static var previews: some View {
    MineSweeperContainer()
  }
}
