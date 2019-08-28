//
//  Style+Color.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/28/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import UIKit
import SwiftUI

extension Color {
  static func colorForAdjacentCount(_ count: Int) -> Color {
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

extension UIColor {
  static func colorForAdjacentCount(_ count: Int) -> UIColor {
    switch count {
    case 1:
      return UIColor.blue
    case 2:
      return UIColor.green
    case 3:
      return UIColor.red
    case 4:
      return UIColor(hue: 209.0, saturation: 56.0, brightness: 26.0, alpha: 1.0)
    case 5:
      return UIColor(hue: 353.0, saturation: 24.0, brightness: 26.0, alpha: 1.0)
    case 6:
      return UIColor(hue: 176.0, saturation: 70.0, brightness: 100.0, alpha: 1.0)
    case 7:
      return UIColor.black
    default:
      return UIColor.gray
    }
  }
}
