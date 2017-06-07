//
//  CSAdvancedTeamMemberCell.h
//  NIM
//
//  Created by chris on 15/3/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

@protocol CSAdvancedTeamMemberCellActionDelegate <NSObject>

- (void)didSelectAddOpeartor;

@end


@interface CSAdvancedTeamMemberCell : UITableViewCell

@property(nonatomic,weak) id<CSAdvancedTeamMemberCellActionDelegate>delegate;

- (void)rereshWithTeam:(NIMTeam*)team
               members:(NSArray*)members
                 width:(CGFloat)width;
@end
