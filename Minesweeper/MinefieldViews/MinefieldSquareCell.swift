//
//  MinefieldSquareCell.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/28/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import UIKit

class MinefieldSquareCell: UICollectionViewCell {
  
  let label = UILabel()
  let imageView = UIImageView()
  var square: Square?
  
  static let reuseIdentifier = "minfield-square-cell-reuse-identifier"
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  required init?(coder: NSCoder) {
    fatalError("not implemnted")
  }
  
  func setup(square: Square) {
    self.square = square
    if square.isRevealed {
      label.isHidden = false
      label.text = String(square.adjacent)
      label.textColor = UIColor.colorForAdjacentCount(square.adjacent)
      backgroundColor = UIColor.white
      if square.isMined && !square.flagged {
        backgroundColor = UIColor.red
      } else {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
      }
      
    } else {
      label.isHidden = true
      backgroundColor = UIColor.lightGray
    }
    if square.flagged {
      imageView.image = UIImage(systemName: "flag.fill")
      imageView.isHidden = false
    } else {
      imageView.image = nil
      imageView.isHidden = true
    }
    self.setNeedsDisplay()
  }
}

//Crown by praveen patchu from the Noun Project

extension MinefieldSquareCell {
  func configure() {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 6
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.white.cgColor
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    contentView.addSubview(label)
    
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textAlignment = .center
    
    let inset = CGFloat(2)
    NSLayoutConstraint.activate([
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
    ])
    
    let imageInset = CGFloat(5)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: imageInset),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -imageInset),
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: imageInset),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -imageInset)
    ])
  }
}
