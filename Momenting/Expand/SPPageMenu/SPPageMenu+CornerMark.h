//
// Created by chuchur on 2019-04-04.
// Copyright (c) 2019 MTY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPageMenu.h"

@interface SPPageMenu (CornerMark)

- (void)addCorner:(UIView *)cornerView atIndex:(NSInteger)index;
- (void)hiddenAtIndex:(NSInteger)index;

@end