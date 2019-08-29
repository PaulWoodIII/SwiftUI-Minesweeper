//
//  MinesweeperCollectionView.swift
//  Minesweeper
//
//  Created by Paul Wood on 8/28/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
class MinefieldCoordinator: NSObject, UICollectionViewDelegate {
  
  var dataSource: Minesweeper
  var monitorBoard: Cancellable?
  var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, Square>? = nil
  var collectionView: UICollectionView? {
    didSet {
      if let collectionView = collectionView {
        prepare(collectionView: collectionView)
      }
    }
  }
  
  init(_ dataSource: Minesweeper){
    self.dataSource = dataSource
  }
  
  func prepare(collectionView: UICollectionView) {
    
    monitorBoard = dataSource.boardStream
      .sink { next in
          let snapShot = self.createSnapShot(forBoard: next)
          self.collectionViewDataSource?.apply(snapShot, animatingDifferences: false)
      }
    
    collectionViewDataSource =
      UICollectionViewDiffableDataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, square) -> UICollectionViewCell? in
          let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MinefieldSquareCell.reuseIdentifier,
        for: indexPath) as! MinefieldSquareCell
      cell.setup(square: square)
      return cell
    })
    collectionViewDataSource!.apply(createSnapShot(forBoard: self.dataSource.board))
    collectionView.dataSource = collectionViewDataSource
    collectionView.delegate = self
  }
  
  func update() {
    let snapShot = self.createSnapShot(forBoard: self.dataSource.board)
    self.collectionViewDataSource?.apply(snapShot)
  }
  
  func createSnapShot(forBoard: Board) -> NSDiffableDataSourceSnapshot<Int, Square> {
    var snapshot: NSDiffableDataSourceSnapshot<Int, Square> = NSDiffableDataSourceSnapshot<Int, Square>()
    snapshot.appendSections(Array<Int>(0...forBoard.rows - 1))
    let squares = Array<Square>(forBoard)
    for row in 0...forBoard.rows - 1{
      let arraySlice = Array(squares[(forBoard.rows * row)..<(forBoard.rows * row + forBoard.rows)])
      snapshot.appendItems(arraySlice, toSection: row)
    }
    return snapshot
  }
  
  func emptySnapshot(forBoard: Board) -> NSDiffableDataSourceSnapshot<Int, Square> {
    var snapshot: NSDiffableDataSourceSnapshot<Int, Square> = NSDiffableDataSourceSnapshot<Int, Square>()
    snapshot.appendSections(Array<Int>(0...forBoard.rows - 1))
    return snapshot // is this empty?
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    #if DEBUG
    print(collectionView.visualRecursiveDescription ?? "Description Not Available")
    #endif
    dataSource.onSelect(row: indexPath.section, col: indexPath.row)
  }
}

struct Minefield: UIViewRepresentable {

  var dataSource: Minesweeper
  var size: CGSize
  
  func makeUIView(context: UIViewRepresentableContext<Minefield>) -> UICollectionView {
    let layout = context.coordinator.createLayout(size: dataSource.board.rows)
    let min = CGFloat.minimum(self.size.width, self.size.height)
    let squareSize = CGSize(width: min, height: min)
    let collectionView =
      UICollectionView(frame: CGRect(origin: CGPoint.zero, size: squareSize),
                       collectionViewLayout: layout)
    collectionView.backgroundColor = UIColor.systemBackground
    collectionView.register(MinefieldSquareCell.self,
                            forCellWithReuseIdentifier: MinefieldSquareCell.reuseIdentifier)
    context.coordinator.collectionView = collectionView
    return collectionView
  }
  
  func updateUIView(_ uiView: UICollectionView,
                    context: UIViewRepresentableContext<Minefield>) {
    context.coordinator.update()
  }
  
  typealias UIViewType = UICollectionView
  
  func makeCoordinator() -> MinefieldCoordinator {
    let coordinator = MinefieldCoordinator(dataSource)
    return coordinator
  }
}

extension MinefieldCoordinator {
  fileprivate func createLayout(size: Int) -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/CGFloat(size)),
                                          heightDimension: .fractionalWidth(1.0/CGFloat(size)))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalWidth(1.0/CGFloat(size)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    let spacing = CGFloat(0)
    group.interItemSpacing = .fixed(spacing)
    
    let section = NSCollectionLayoutSection(group: group)
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}
