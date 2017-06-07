//
//  CSSMeetingWhiteboardViewController.h
//  NIMEducationDemo
//
//  Created by fenric on 16/10/25.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSDocumentViewController.h"




@interface CSSMeetingWhiteboardViewController : UIViewController<CSSDocumentViewControllerDelegate>

- (instancetype)initWithChatroom:(NIMChatroom *)room;

- (void)checkPermission;

@end
