//
//  CSAttributedLabelDefines.h
//  CSAttributedLabel
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 www.xiangwangfeng.com. All rights reserved.
//

#ifndef CSAttributedLabel_CSAttributedLabelDefines_h
#define CSAttributedLabel_CSAttributedLabelDefines_h

typedef enum
{
    NIMImageAlignmentTop,
    NIMImageAlignmentCenter,
    NIMImageAlignmentBottom
} NIMImageAlignment;

@class CSAttributedLabel;

@protocol CSAttributedLabelDelegate <NSObject>
- (void)CSAttributedLabel:(CSAttributedLabel *)label
             clickedOnLink:(id)linkData;

@end

typedef NSArray *(^NIMCustomDetectLinkBlock)(NSString *text);

//如果文本长度小于这个值,直接在UI线程做Link检测,否则都dispatch到共享线程
#define NIMMinAsyncDetectLinkLength 50

#define NIMIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)

#endif
