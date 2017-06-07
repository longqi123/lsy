//
//  CSSSpellingCenter.h
//  NIM
//  用于拼音全称和简称生成查询读取的类
//  Created by amao on 13-1-21.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSpellingUnit : NSObject<NSCoding>
@property (nonatomic,strong)    NSString *fullSpelling;
@property (nonatomic,strong)    NSString *shortSpelling;
@end

@interface CSSpellingCenter : NSObject
{
    NSMutableDictionary *_spellingCache;    //全拼，简称cache
    NSString *_filepath;
}
+ (CSSpellingCenter *)sharedCenter;
- (void)saveSpellingCache;          //写入缓存

- (CSSpellingUnit *)spellingForString: (NSString *)source;    //全拼，简拼 (全是小写)
- (NSString *)firstLetter: (NSString *)input;               //首字母
@end
