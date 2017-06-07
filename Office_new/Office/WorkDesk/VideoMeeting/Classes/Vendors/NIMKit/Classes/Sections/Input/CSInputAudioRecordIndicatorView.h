//
//  CSInputAudioRecordIndicatorView.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CSInputView.h"

@interface CSInputAudioRecordIndicatorView : UIView

@property (nonatomic, assign) NIMAudioRecordPhase phase;

@property (nonatomic, assign) NSTimeInterval recordTime;

@end
