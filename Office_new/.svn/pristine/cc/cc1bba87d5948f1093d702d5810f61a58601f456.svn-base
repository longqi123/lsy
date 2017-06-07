//
//  CSSessionVideoContentView.m
//  CSKit
//
//  Created by chris on 15/4/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSessionVideoContentView.h"
#import "CSMessageModel.h"
#import "UIView+CS.h"
#import "UIImage+CS.h"
#import "CSLoadProgressView.h"

@interface CSSessionVideoContentView()

@property (nonatomic,strong,readwrite) UIImageView * imageView;

@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) CSLoadProgressView * progressView;

@end

@implementation CSSessionVideoContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_imageView];
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage cs_imageInKit:@"icon_play_normal"] forState:UIControlStateNormal];
        [_playBtn sizeToFit];
        [_playBtn setUserInteractionEnabled:NO];
        [self addSubview:_playBtn];
        
        _progressView = [[CSLoadProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _progressView.maxProgress = 1.0;
        [self addSubview:_progressView];

        
    }
    return self;
}

- (void)refresh:(CSMessageModel *)data{
    [super refresh:data];
    NIMVideoObject * videoObject = (NIMVideoObject*)self.model.message.messageObject;
    UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
    self.imageView.image         = image;
    _progressView.hidden         = (self.model.message.deliveryState != NIMMessageDeliveryStateDelivering);
    if (!_progressView.hidden) {
        [_progressView setProgress:[[[NIMSDK sharedSDK] chatManager] messageTransportProgress:self.model.message]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentsize = self.model.contentSize;
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    self.imageView.frame  = imageViewFrame;
    _progressView.frame   = self.bounds;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
    
    self.playBtn.nim_centerX = self.nim_width  * .5f;
    self.playBtn.nim_centerY = self.nim_height * .5f;
}


- (void)onTouchUpInside:(id)sender
{
    CSKitEvent *event = [[CSKitEvent alloc] init];
    event.eventName = CSKitEventNameTapContent;
    event.message = self.model.message;
    [self.delegate onCatchEvent:event];
}

- (void)updateProgress:(float)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }
    self.progressView.progress = progress;
}



@end
