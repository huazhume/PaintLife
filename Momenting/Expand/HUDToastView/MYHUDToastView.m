//
//  MYHUDToastView.m
//  Meiyu
//
//  Created by QingyunLiao on 2/17/16.
//  Copyright © 2016 jimeiyibao. All rights reserved.
//

#import "MYHUDToastView.h"

#import "Masonry.h"

static CGFloat const kMargin = 10;

@interface MYHUDToastView ()

@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) CGRect containerRect;

@end

@implementation MYHUDToastView

+ (instancetype)HUDToastViewWithAttributedString:(NSAttributedString *)attributedString
                                          inRect:(CGRect)rect
{
    MYHUDToastView *HUDToastView = [[self alloc] initWithAttributedString:attributedString inRect:rect];
    return HUDToastView;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
                                  inRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.attributedString = attributedString;
        self.containerRect = rect;

        [self setupHUDToastView];
    }
    return self;
}

- (void)setupHUDToastView
{
    self.layer.cornerRadius = 6;

//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = 0.8f;
//    self.layer.shadowRadius = 6.0f;
//    self.layer.shadowOffset = CGSizeMake(4.0, 4.0);

    self.backgroundColor = [[UIColor colorWithHex:0x262728] colorWithAlphaComponent:0.9f];

    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.alpha = 1.0;

    [messageLabel setAttributedText:self.attributedString];

    CGSize maxSizeMessage = CGSizeMake((self.containerRect.size.width * 0.8),
                                       self.containerRect.size.height * 0.8);

    NSDictionary *attribute = @{NSFontAttributeName : messageLabel.font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize expectedSizeMessage = [self.attributedString.string boundingRectWithSize:maxSizeMessage
                                                                            options:options
                                                                         attributes:attribute
                                                                            context:nil]
                                     .size;

    CGFloat expectedWidth = ceilf(expectedSizeMessage.width);
    CGFloat expectedHeight = ceilf(expectedSizeMessage.height);
    [self addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin * 2);
        make.top.mas_equalTo(self.mas_top).offset(kMargin);
        make.size.mas_equalTo(CGSizeMake(expectedWidth, expectedHeight));
    }];

    CGFloat width = kMargin * 4 + expectedWidth;
    CGFloat height = kMargin * 2 + expectedHeight;

    self.frame = CGRectMake(0, 0, width, height);

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
}

@end
