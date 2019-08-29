//
//  UIView+VisualRecursiveDescription.swift
//
//  Created by Paul Wood on 8/29/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

extension UIView {
  var visualRecursiveDescription: String? {
    return UIView.visualRecursiveDescription(self)
  }
}
