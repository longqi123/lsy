//
//  CSSDocumentViewController.h
//  NIMEducationDemo
//
//  Created by Simon Blue on 16/12/13.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSDocumentHandler.h"
#import "CSSDocumentCell.h"

@protocol CSSDocumentViewControllerDelegate <NSObject>

-(void)showDocOnWhiteboard:(NIMDocTranscodingInfo*)info;

@end


@interface CSSDocumentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CSSDocumentHandlerDelegate,CSSDocumentCellDelegate>

@property (nonatomic,weak) id <CSSDocumentViewControllerDelegate> delegate;

@end
