//
//  CSSChatroomConfig.m
//  NIM
//
//  Created by chris on 15/12/14.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "CSSChatroomConfig.h"
#import "CSSChatroomMessageDataProvider.h"
#import "CSSChatroomCellLayoutConfig.h"

@interface CSSChatroomConfig()

@property (nonatomic,strong) CSSChatroomMessageDataProvider *provider;

@end

@implementation CSSChatroomConfig

- (instancetype)initWithChatroom:(NSString *)roomId{
    self = [super init];
    if (self) {
        self.provider = [[CSSChatroomMessageDataProvider alloc] initWithChatroom:roomId];
    }
    return self;
}

- (id<CSKitMessageProvider>)messageDataProvider{
    return self.provider;
}


- (NSArray<NSNumber *> *)inputBarItemTypes{
    return @[
               @(CSInputBarItemTypeTextAndRecord),
               @(CSInputBarItemTypeEmoticon),
               @(CSInputBarItemTypeMore)
            ];
}


- (NSArray *)mediaItems
{
    return @[
             [CSMediaItem item:NTESMediaButtonJanKenPon
                    normalImage:[UIImage imageNamed:@"icon_jankenpon_normal"]
                  selectedImage:[UIImage imageNamed:@"icon_jankenpon_pressed"]
                          title:@"石头剪刀布"]];
}


- (BOOL)disableCharlet{
    return YES;
}

- (BOOL)autoFetchWhenOpenSession
{
    return NO;
}


- (id<CSCellLayoutConfig>)layoutConfigWithMessage:(NIMMessage *)message{
    return [CSSChatroomCellLayoutConfig new];
}

@end
