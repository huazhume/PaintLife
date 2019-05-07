//
// Created by chuchur on 2019-04-04.
// Copyright (c) 2019 MTY. All rights reserved.
//

#import "SPPageMenu+CornerMark.h"

static CGFloat kCornerMarkTag = 71023;

@implementation SPPageMenu (CornerMark)

- (void)addCorner:(UIView *)cornerView atIndex:(NSInteger)index {
    NSArray<UIButton *> *buttons = [self valueForKey:@"_buttons"];
    if (buttons.count < index) return;

    [XBCommonMethods commonMethods1];
    UIButton *item = buttons[index];
    if ([item viewWithTag:kCornerMarkTag]) return;
    else {
        cornerView.tag = kCornerMarkTag;
        [item addSubview:cornerView];
//        cornerView.centerY = item.titleLabel.top;
//        cornerView.left = item.titleLabel.right + 3;
    }
}

- (void)hiddenAtIndex:(NSInteger)index {
    [XBCommonMethods commonMethods1];
    NSArray<UIButton *> *buttons = [self valueForKey:@"_buttons"];
    if (buttons.count < index) return;

    UIButton *item = buttons[index];
    [item viewWithTag:kCornerMarkTag].hidden = true;
}


@end
