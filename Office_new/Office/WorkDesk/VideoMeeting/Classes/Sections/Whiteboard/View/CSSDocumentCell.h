//
//  CSSDocumentCell.h
//  NIMEducationDemo
//
//  Created by Simon Blue on 16/12/13.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DocDownloadCompleteBlock)( NSError * error);
typedef void(^DocDeleteCompleteBlock)( NSError * error);

@protocol CSSDocumentCellDelegate <NSObject>


-(void)onPressedUseDoc:(NIMDocTranscodingInfo*)info ;
-(void)onPressedDeleteDoc:(NIMDocTranscodingInfo*)info;
-(void)onPressedDownloadDoc:(NIMDocTranscodingInfo*)info;
-(BOOL)checkDocInLocal:(NIMDocTranscodingInfo*)info;


@end

@interface CSSDocumentCell : UITableViewCell

@property(nonatomic,weak)id<CSSDocumentCellDelegate> delegate;
-(void)refresh:(NIMDocTranscodingInfo*)info;

@end
