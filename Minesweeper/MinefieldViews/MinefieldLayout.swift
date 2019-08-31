//
//  MinefieldLayout.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/30/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import Foundation

class MinefieldLayout: UICollectionViewFlowLayout {
  
  init(rows: Int, cols: Int) {
    self.rows = rows
    self.cols = cols
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var contentBounds = CGRect.zero
  var cols = 10
  var rows = 10
  var cachedAttributes = [UICollectionViewLayoutAttributes]()
  var cachedSize: CGSize?
  
  override func prepare() {
    super.prepare()
    
    guard let collectionView = collectionView else { return }
    cachedAttributes.removeAll()
    let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
    let calculatedWidth = (availableWidth / CGFloat(cols)).rounded(.down)
    let cellWidth = min(10, calculatedWidth)
    self.itemSize = CGSize(width: cellWidth, height: cellWidth)
    
    self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing,
                                     left: 0.0, bottom: 0.0, right: 0.0)
    self.sectionInsetReference = .fromSafeArea
  }
  
  override var collectionViewContentSize: CGSize {
    let width = self.itemSize.width * CGFloat(rows)
    let height = self.itemSize.width * CGFloat(cols)
    return CGSize(width: width, height: height)
  }
}
