//
//  MTLaunchCollectionCell.m
//  Momenting
//
//  Created by xiaobai zhang on 2019/4/28.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTLaunchCollectionCell.h"

@interface MTLaunchCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;

@end

@implementation MTLaunchCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
   self.contentBgView.layer.borderColor = [UIColor colorWithHex:0x333333].CGColor;
    self.contentBgView.layer.borderWidth = 0.5;
    self.contentBgView.layer.masksToBounds = YES;
    self.contentBgView.layer.cornerRadius = 3;
    self.contentLabel.textColor = [UIColor blackColor];
    // Initialization code
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.contentLabel.text = title;
}

- (void)setIsHSelected:(BOOL)isHSelected
{
    _isHSelected = isHSelected;
//    01CA5E
    self.contentLabel.textColor = isHSelected ? [UIColor colorWithHex:0x01CA5E] : [UIColor blackColor];
    self.contentBgView.layer.borderColor = isHSelected ? [UIColor colorWithHex:0x01CA5E].CGColor : [UIColor colorWithHex:0x333333].CGColor;
}

+ (CGSize)getSizeWithContent:(NSString *)content maxWidth:(CGFloat)maxWidth customHeight:(CGFloat)cellHeight
{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize size = [content boundingRectWithSize:CGSizeMake(maxWidth, cellHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :
                                                                                                                                                   [UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style} context:nil].size;

    return CGSizeMake(size.width + 30, cellHeight);
}


@end
