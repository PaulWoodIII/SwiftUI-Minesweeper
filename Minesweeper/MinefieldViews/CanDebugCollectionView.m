//
//  CanDebugCollectionView.m
//  Minesweeper
//
//  Created by Paul Wood on 8/28/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

#import "CanDebugCollectionView.h"
@import UIKit;

@implementation CanDebugCollectionView

- (void)debugFrame:(UICollectionView *)collectionView {
  NSLog(@"%@",collectionView.description);
}

@end
