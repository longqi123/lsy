//
//  CSInputView.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSInputTextView.h"
#import "CSInputProtocol.h"
#import "CSSessionConfig.h"

@class CSInputMoreContainerView;
@class CSInputEmoticonContainerView;
@class CSInputToolBar;

typedef NS_ENUM(NSInteger, NIMInputType){
    InputTypeText = 1,
    InputTypeEmot = 2,
    InputTypeAudio = 3,
    InputTypeMedia = 4,
};

//typedef NS_ENUM(NSInteger, NIMAudioRecordPhase) {
//    AudioRecordPhaseStart,
//    AudioRecordPhaseRecording,
//    AudioRecordPhaseCancelling,
//    AudioRecordPhaseEnd
//};


@protocol NIMInputDelegate <NSObject>

@optional

- (void)showInputView;
- (void)hideInputView;

- (void)inputViewSizeToHeight:(CGFloat)toHeight
                showInputView:(BOOL)show;
@end

@interface CSInputView : UIView

@property (nonatomic, assign) NSInteger              maxTextLength;
@property (nonatomic, assign) CGFloat                inputBottomViewHeight;

@property (assign, nonatomic, getter=isRecording) BOOL recording;

@property (strong, nonatomic)  CSInputToolBar *toolBar;
//@property (strong, nonatomic)  CSInputMoreContainerView *moreContainer;
//@property (strong, nonatomic)  CSInputEmoticonContainerView *emoticonContainer;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setInputDelegate:(id<NIMInputDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<CSInputActionDelegate>)actionDelegate;
- (void)setInputConfig:(id<CSSessionConfig>)config;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;
- (void)updateAudioRecordTime:(NSTimeInterval)time;
- (void)updateVoicePower:(float)power;

@end
