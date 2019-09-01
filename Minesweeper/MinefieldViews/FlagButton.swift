//
//  FlagButton.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/31/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import SwiftUI

struct FlagButton: View {
  
  var flagMode: Bool
  var action: (() -> Void)
  
  var body: some View {
    Button(action: action) {
      Image(systemName: flagMode ? "flag.fill" : "flag")
        .font(.largeTitle)
        .foregroundColor(Color.accentColor)
        .padding(40)
        .background(
          Circle().foregroundColor(Color.accentColor.opacity(0.5))
          
      )
    }
  }
}

struct FlagButton_Previews: PreviewProvider {
  static var previews: some View {
    FlagButton(flagMode: true) {
      
    }
  }
}
