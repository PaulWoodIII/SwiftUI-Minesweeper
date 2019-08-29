//
//  UIView+VisualRecursiveDescription.m
//
//  Created by Paul Wood on 8/28/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

#import "UIView+VisualRecursiveDescription.h"
@import UIKit;

@implementation UIView (VisualRecursiveDescription)

+ (NSString * _Nullable)visualRecursiveDescription:(UIView *)view {
#ifdef DEBUG
  SEL selector = NSSelectorFromString(@"_visualRecursiveDescription");
  if ([view canPerformAction:selector withSender:nil]) {
    IMP imp = [view methodForSelector:selector];
    NSString*  (*func)(id, SEL) = (void *)imp;
    NSString *visualDebugDescription =  func(view, selector);
    return visualDebugDescription;
  }
#endif
  return nil;
}

@end
