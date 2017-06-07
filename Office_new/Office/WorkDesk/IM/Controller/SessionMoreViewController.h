//
//  SessionMoreTableViewController.h
//  Office
//
//  Created by roger on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"

@protocol SessionMoreDelegate <NSObject>

- (void)startChat;

- (void)startSession;

@end

@interface SessionMoreViewController : UIViewController

@property (nonatomic,weak) id<SessionMoreDelegate> delegate;
@property (nonatomic, strong) FPPopoverController *popover;

@end
