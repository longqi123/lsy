//
//  CSSChatroomViewController.h
//  NIM
//
//  Created by chris on 15/12/10.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSSChatroomListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end
