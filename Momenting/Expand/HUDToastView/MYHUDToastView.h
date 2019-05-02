//
//  MYHUDToastView.h
//  Meiyu
//
//  Created by QingyunLiao on 2/17/16.
//  Copyright © 2016 jimeiyibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYHUDToastView : UIView

+ (instancetype)HUDToastViewWithAttributedString:(NSAttributedString *)attributedString
                                          inRect:(CGRect)rect;

@end
