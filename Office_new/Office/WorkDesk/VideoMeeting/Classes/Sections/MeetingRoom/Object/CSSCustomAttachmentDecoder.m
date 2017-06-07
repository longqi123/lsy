//
//  CSSCustomAttachmentDecoder.m
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "CSSCustomAttachmentDecoder.h"
#import "CSSCustomAttachmentDefines.h"
#import "CSSJanKenPonAttachment.h"
#import "CSSSnapchatAttachment.h"
#import "CSSChartletAttachment.h"
#import "CSSMeetingControlAttachment.h"
#import "NSDictionary+CSSJson.h"
#import "CSSSessionUtil.h"

@implementation CSSCustomAttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment = nil;

    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:CMType];
            NSDictionary *data = [dict jsonDict:CMData];
            switch (type) {
                case CustomMessageTypeJanKenPon:
                {
                    attachment = [[CSSJanKenPonAttachment alloc] init];
                    ((CSSJanKenPonAttachment *)attachment).value = [data jsonInteger:CMValue];
                }
                    break;
                case CustomMessageTypeSnapchat:
                {
                    attachment = [[CSSSnapchatAttachment alloc] init];
                    ((CSSSnapchatAttachment *)attachment).md5 = [data jsonString:CMMD5];
                    ((CSSSnapchatAttachment *)attachment).url = [data jsonString:CMURL];
                    ((CSSSnapchatAttachment *)attachment).isFired = [data jsonBool:CMFIRE];
                }
                    break;
                case CustomMessageTypeChartlet:
                {
                    attachment = [[CSSChartletAttachment alloc] init];
                    ((CSSChartletAttachment *)attachment).chartletCatalog = [data jsonString:CMCatalog];
                    ((CSSChartletAttachment *)attachment).chartletId      = [data jsonString:CMChartlet];
                }
                    break;
                    
                case CustomMessageTypeMeetingControl:
                {
                    attachment = [[CSSMeetingControlAttachment alloc] init];
                    ((CSSMeetingControlAttachment *)attachment).roomID = [data jsonString:CMRoomID];
                    ((CSSMeetingControlAttachment *)attachment).command = [data jsonInteger:CMCommand];
                    ((CSSMeetingControlAttachment *)attachment).uids = [data jsonArray:CMUIDs];

                }
                    break;

                default:
                    break;
            }
            attachment = [self checkAttachment:attachment] ? attachment : nil;
        }
    }
    return attachment;
}


- (BOOL)checkAttachment:(id<NIMCustomAttachment>)attachment{
    BOOL check = NO;
    if ([attachment isKindOfClass:[CSSJanKenPonAttachment class]]) {
        NSInteger value = [((CSSJanKenPonAttachment *)attachment) value];
        check = (value>=CustomJanKenPonValueKen && value<=CustomJanKenPonValuePon) ? YES : NO;
    }
    else if ([attachment isKindOfClass:[CSSSnapchatAttachment class]]) {
        check = YES;
    }
    else if ([attachment isKindOfClass:[CSSChartletAttachment class]]) {
        NSString *chartletCatalog = ((CSSChartletAttachment *)attachment).chartletCatalog;
        NSString *chartletId      =((CSSChartletAttachment *)attachment).chartletId;
        check = chartletCatalog.length&&chartletId.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[CSSMeetingControlAttachment class]]) {
        return YES;
    }
    return check;
}
@end
