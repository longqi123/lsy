//
//  CSSessionUnknowContentView.h
//  CSKit
//
//  Created by chris on 15/3/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSessionUnknowContentView.h"
#import "CSAttributedLabel+CSKit.h"
#import "UIView+CS.h"
#import "CSMessageModel.h"
#import "CSGlobalMacro.h"

@interface CSSessionUnknowContentView()

@property (nonatomic,strong) UILabel *label;

@end

@implementation CSSessionUnknowContentView

-(instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:14.f];
        _label.backgroundColor = [UIColor clearColor];
        _label.userInteractionEnabled = NO;
        [self addSubview:_label];
    }
    return self;
}

- (void)refresh:(CSMessageModel *)data{
    [super refresh:data];
    NSString *text = CSKit_Unknow_Message_Tip;
    [self.label setText:text];
    [self.label sizeToFit];
    if (!self.model.message.isOutgoingMsg) {
        self.label.textColor = [UIColor blackColor];
    }else{
        self.label.textColor = [UIColor whiteColor];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _label.nim_centerX = self.nim_width  * .5f;
    _label.nim_centerY = self.nim_height * .5f;
}

@end
