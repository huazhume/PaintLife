//
//  MTLaunchViewCell.h
//  Momenting
//
//  Created by xiaobai zhang on 2019/4/28.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTLaunchViewCellDelegate <NSObject>

- (void)lanuchViewCell:(NSString *)title;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MTLaunchViewCell : UITableViewCell

@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) id <MTLaunchViewCellDelegate> delegate;

+ (CGFloat)heightForCellWithCacheArray:(NSArray *)array;

- (void) setDataArray:(NSArray *)dataArray selectTitles:(NSArray *)selectedArray;

@end

NS_ASSUME_NONNULL_END
