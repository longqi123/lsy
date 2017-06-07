//
//  CSSessionLocationContentView.m
//  CSKit
//
//  Created by chris on 15/2/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSessionLocationContentView.h"
#import "CSMessageModel.h"
#import "UIView+CS.h"
#import "UIImage+CS.h"

@interface CSSessionLocationContentView()

@property (nonatomic,strong) UIImageView * imageView;

@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation CSSessionLocationContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        UIImage *image = [UIImage cs_imageInKit:@"icon_map"];
        _imageView  = [[UIImageView alloc] initWithImage:image];
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.cornerRadius = 13.0;
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.frame = _imageView.bounds;
        _imageView.layer.mask = maskLayer;

        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)refresh:(CSMessageModel *)data{
    [super refresh:data];
    NIMLocationObject * locationObject = (NIMLocationObject*)self.model.message.messageObject;
    self.titleLabel.text = locationObject.title;
}

- (void)onTouchUpInside:(id)sender
{
    CSKitEvent *event = [[CSKitEvent alloc] init];
    event.eventName = CSKitEventNameTapContent;
    event.message = self.model.message;
    [self.delegate onCatchEvent:event];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.nim_width = self.nim_width - 20;
    _titleLabel.nim_height= 35.f;
    self.titleLabel.nim_centerY = 90.f;
    self.titleLabel.nim_centerX = self.nim_width * .5f;
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentsize             = self.model.contentSize;
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    self.imageView.frame  = imageViewFrame;
}


@end
