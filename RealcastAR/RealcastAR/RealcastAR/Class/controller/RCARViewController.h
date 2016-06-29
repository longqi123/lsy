//
//  RCARViewController.h
//  ProjectTemplet
//
//  Created by fish on 16/4/22.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <realmaxARSDK/RXSDKInterface.h>

@protocol RCARDelegate <NSObject>

@optional
/**
 *  AR加载成功代理，可以在此加载用户界面
 *
 *  @param ui 用户界面层
 */
- (void)ARReady:(UIView*)userView;

/**
 *  截屏代理，调用截屏方法时回调
 *
 *  @param image 截屏返回图像
 */
-(void)screenCaptured:(UIImage *)image;

@end

@interface RCARViewController : UIViewController

/**
 *  AR代理
 */
@property (nonatomic, weak) id<RCARDelegate>delegate;

/**
 *  截屏
 */
-(void)capture;

/**
 *  重新加载AR
 */
-(void)reload;

@property (nonatomic, copy) NSString *xmlPath;       //下载下来的xml
@property (nonatomic, copy) NSString *jsonfile;      //下载下来的 json
@property (nonatomic, strong)NSDictionary *mediaDic; //xml 里面一张识别图对应相应模型的字典
@property (nonatomic, copy)NSString *otherChanelID;  //打开其它频道的频道号

@end
