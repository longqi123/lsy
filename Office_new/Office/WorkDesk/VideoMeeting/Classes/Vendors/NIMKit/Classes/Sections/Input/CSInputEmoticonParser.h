//
//  CSInputEmoticonParser.h
//  CSKit
//
//  Created by chris.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    NIMInputTokenTypeText,
    NIMInputTokenTypeEmoticon,
    
} CSInputTokenType;

@interface CSInputTextToken : NSObject
@property (nonatomic,copy)      NSString    *text;
@property (nonatomic,assign)    CSInputTokenType   type;
@end


@interface CSInputEmoticonParser : NSObject
+ (instancetype)currentParser;
- (NSArray *)tokens:(NSString *)text;
@end
