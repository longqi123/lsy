//
//  NSString+CS.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (CS)

- (CGSize)cs_stringSizeWithFont:(UIFont *)font;

- (NSString *)cs_MD5String;

- (NSUInteger)cs_getBytesLength;

- (NSString *)cs_stringByDeletingPictureResolution;
@end
