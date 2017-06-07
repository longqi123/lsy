//
//  CSImageContentConfig.m
//  CSKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "CSImageContentConfig.h"
#import "UIImage+CS.h"

@implementation CSImageContentConfig
- (CGSize)contentSize:(CGFloat)cellWidth
{
    CGFloat attachmentImageMinWidth  = (cellWidth / 4.0);
    CGFloat attachmentImageMinHeight = (cellWidth / 4.0);
    CGFloat attachmemtImageMaxWidth  = (cellWidth - 184);
    CGFloat attachmentImageMaxHeight = (cellWidth - 184);
    CGSize  contentSize = CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight);
    
    NIMImageObject *imageObject = (NIMImageObject*)[self.message messageObject];
    if (!CGSizeEqualToSize(imageObject.size, CGSizeZero))
    {
        contentSize = [UIImage cs_sizeWithImageOriginSize:imageObject.size
                                                   minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                   maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight )];
    }
    return contentSize;
}

- (NSString *)cellContent
{
    return @"CSSessionImageContentView";
}

- (UIEdgeInsets)contentViewInsets
{
    return self.message.isOutgoingMsg ? UIEdgeInsetsMake(3,3,3,8) : UIEdgeInsetsMake(3,8,3,3);
}
@end
