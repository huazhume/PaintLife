//
//  MTPaintSectionView.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/5/1.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTPaintSectionView.h"

@interface MTPaintSectionView ()

@end

@implementation MTPaintSectionView

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MTPaintSectionView" owner:nil options:nil];
    if (views && views.count > 0) {
        return [views firstObject];
    }
    return nil;
}

+ (CGFloat)viewHeight
{
    return 35.f;
}


@end
