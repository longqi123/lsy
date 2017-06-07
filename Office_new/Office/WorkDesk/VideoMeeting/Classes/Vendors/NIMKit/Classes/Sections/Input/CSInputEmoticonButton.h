//
//  CSInputEmoticonButton.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSInputEmoticon;

@protocol NIMEmoticonButtonTouchDelegate <NSObject>

- (void)selectedEmoticon:(CSInputEmoticon*)emoticon catalogID:(NSString*)catalogID;

@end



@interface CSInputEmoticonButton : UIButton

@property (nonatomic, strong) CSInputEmoticon *emoticonData;

@property (nonatomic, copy)   NSString         *catalogID;

@property (nonatomic, weak)   id<NIMEmoticonButtonTouchDelegate> delegate;

+ (CSInputEmoticonButton*)iconButtonWithData:(CSInputEmoticon*)data catalogID:(NSString*)catalogID delegate:( id<NIMEmoticonButtonTouchDelegate>)delegate;

- (void)onIconSelected:(id)sender;

@end
