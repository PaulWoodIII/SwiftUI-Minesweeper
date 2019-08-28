//
//  CanDebugCollectionView.h
//  Minesweeper
//
//  Created by Paul Wood on 8/28/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CanDebugCollectionView : NSObject
- (void)debugFrame:(UICollectionView *)collectionView;
@end

NS_ASSUME_NONNULL_END
