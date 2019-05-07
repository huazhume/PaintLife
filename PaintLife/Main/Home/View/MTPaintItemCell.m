//
//  MTPaintItemCell.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/5/1.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTPaintItemCell.h"
#import "UIImage+ImageCompress.h"
#import "MTMediaFileManager.h"
#import <UIImageView+WebCache.h>

@interface MTPaintItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MTPaintItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    if (![imageUrl containsString:@"min_"]) {
        return;
    }
    NSString *path = [[MTMediaFileManager sharedManager] getDocumntMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGEBATE_TYPE];
    NSString *beta_path = [NSString stringWithFormat:@"%@/%@",path,imageUrl];
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:beta_path]];
    
}

- (void)setWebUrl:(NSString *)webUrl
{
    _webUrl = webUrl;
    
    self.imageView.image = [UIImage imageNamed:webUrl];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:webUrl]];
    
}


- (void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
    NSString *path = [[MTMediaFileManager sharedManager] getDocumntMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGE_TYPE];
    NSString *beta_path = [NSString stringWithFormat:@"%@/%@",path,fileName];
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:beta_path]];
}
@end
