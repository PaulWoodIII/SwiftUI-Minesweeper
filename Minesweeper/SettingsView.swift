//
//  SettingsView.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI
import MinesweeperGameplay

struct SettingsView: View {
  
  @ObservedObject var minesweeper: Minesweeper
  
  var body: some View {
    Form{
      Section(header: Text("Gameplay")) {
        Toggle(isOn: minesweeper.allowFlagsBinding) {
          Text("Allow Flags")
        }        
        Picker("Difficulty", selection: minesweeper.difficultyLevelBinding) {
          ForEach(DifficultyLevel.allCases) { level in
            Text(level.displayString).tag(level.rawValue)
          }
        }.pickerStyle(SegmentedPickerStyle())
      }.collapsible(true)
    }.navigationBarTitle(Text("Settings"))
  }
}
