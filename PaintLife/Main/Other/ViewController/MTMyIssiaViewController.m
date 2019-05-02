//
//  MTMyIssiaViewController.m
//  PaintLife
//
//  Created by xiaobai zhang on 2019/4/21.
//  Copyright © 2019年 xiaobai zhang. All rights reserved.
//

#import "MTMyIssiaViewController.h"
#import "FBFeedSectionView.h"
#import "MTActionAlertView.h"

@interface MTMyIssiaViewController ()
<UITextViewDelegate,UIActionSheetDelegate,FBFeedSectionViewDelegate>

@property (nonatomic , strong) UITextView * textView;
@property (nonatomic , strong) UIButton * addButton;
@property (nonatomic , strong) UILabel * placeHold;
@property (nonatomic , strong) UIButton * selectedButton;


@property (nonatomic , strong) UIView * bottomView;
@property (nonatomic , assign) CGFloat leftMargin;
@property (nonatomic , assign) CGFloat imageWidth;
@property (nonatomic , assign) BOOL requestFinished;
@property (nonatomic , strong) UIButton * rightButton;

@property (nonatomic , strong) UIView *contactView;
@property (nonatomic , strong) FBFeedSectionView *sectionView;
@property (nonatomic , strong) UIScrollView *contentView;

@end

@implementation MTMyIssiaViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _leftMargin = 20;
        _imageWidth = 115;
        _requestFinished = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xfafafa];
    [self.view addSubview:self.contentView];
}
- (IBAction)tijiao:(id)sender {
    [self rightAction];
}

- (void)rightAction {
    
    [self.textView endEditing:YES];
    if (!self.textView.text.length) {
        [UIView showToastInKeyWindow:@"意见反馈不能为空"];
        return;
    }
    
    [MTActionAlertView alertShowWithMessage:@"确定提交吗？" leftTitle:@"提交" leftColor:[UIColor colorWithHex:0xCD6256] rightTitle:@"继续" rightColor:[UIColor colorWithHex:0x333333] callBack:^(NSInteger index) {
        if (index == 2){
            return;
        }
        [UIView showToastInKeyWindow:@"发送成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        _placeHold.hidden = YES;
        _rightButton.alpha = 1;
    }else{
        _placeHold.hidden = NO;
        _rightButton.alpha = 0.5;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - FBFeedSectionViewDelegate
- (void)marketSectionMoreAction
{
    [self sendEmail];
}

-(void)sendEmail
{
    NSMutableString *mailUrl = [NSMutableString string];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"huazhume@163.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //    //添加抄送
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //    //添加密送
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    //    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:@"&subject=联系我们"];
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>Thanks</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

#pragma mark - Lazy
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(17, 20, SCREEN_WIDTH - 34, 210)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor colorWithHex:0x333333];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

-(UILabel *)placeHold{
    if (!_placeHold) {
        _placeHold = [[UILabel alloc] initWithFrame:CGRectMake(22, 26, 0, 0)];
        _placeHold.text = @"请在此描述您的建议与反馈，我们将变得更好";
        _placeHold.font = [UIFont systemFontOfSize:16];

        _placeHold.textColor = [UIColor colorWithHex:0xcccccc];
        [_placeHold sizeToFit];
    }
    return _placeHold;
}



-(UIView *)bottomView{
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH,115)];
    }
    return _bottomView;
}

- (UIView *)contactView{
    if (!_contactView) {
        
        _contactView = [[UIView alloc] init];
        _contactView.frame = CGRectMake(0, self.bottomView.frame.origin.y + 115 + 22, SCREEN_WIDTH, self.view.frame.size.height - self.bottomView.frame.origin.y - self.bottomView.frame.size.height - 22);
        _contactView.backgroundColor = [UIColor whiteColor];
        [_contactView addSubview:self.sectionView];
    }
    return _contactView;
}

- (FBFeedSectionView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [[FBFeedSectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
        _sectionView.delegate = self;
        [_sectionView setTitle:@"联系我们" desc:@""];
        _sectionView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    }
    return _sectionView;
}


- (UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iPhoneTopMargin + 20 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - (iPhoneTopMargin + 20 + 44))];
        _contentView.contentSize = CGSizeMake(SCREEN_WIDTH, _contentView.frame.size.height + 2);
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:self.textView];
        [_contentView addSubview:self.placeHold];
        [_contentView addSubview:self.bottomView];
        [_contentView addSubview:self.addButton];
        [_contentView addSubview:self.contactView];
        _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _contentView;
}
- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

