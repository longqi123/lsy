//
//  RCARLoadDataView.m
//  RealcastAR
//
//  Created by lsy on 16/6/12.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import "RCARLoadDataView.h"
#import "LoadResources.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height  //屏幕高度

@interface RCARLoadDataView ()<LoadResourcesDelegare>
{
    UIProgressView *_progress;
    LoadResources *_res;
    UILabel *_label;
}
@end

@implementation RCARLoadDataView

-(instancetype)initWithFrame:(CGRect)frame chanelID:(NSString *)channelID
{
    self = [super initWithFrame:frame];
    
    self.channelID = channelID;
    
    [self createUI];
    
    return self;
}

-(void)createUI{
    
    //通过频道号下载资源
    _res = [[LoadResources alloc]init];
    _res.delegate = self;
    [_res DownloadResources:_channelID];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(ScreenWidth*24/750, ScreenHeight*40/1334, ScreenWidth*50/750, ScreenWidth*50/750);
    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //刷新按钮
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(ScreenWidth-ScreenWidth*74/750, ScreenHeight*40/1334, ScreenWidth*50/750, ScreenWidth*50/750);
    [refreshBtn setImage:[UIImage imageNamed:@"iconfont-xuanzhuanjiantou"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshBtn];
    
    
    //不能点击的更多按钮
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(ScreenWidth*24/750 + 4 * ScreenWidth*163/750, ScreenHeight-ScreenWidth*74/750 , ScreenWidth*50/750, ScreenWidth*50/750);
    [moreBtn setImage:[UIImage imageNamed:@"jiantou_back"] forState:UIControlStateNormal];
    [self addSubview:moreBtn];

    _progress=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    _progress.frame=CGRectMake(30, ScreenHeight/2, ScreenWidth-60, 50);
    //设置进度条颜色
    _progress.trackTintColor=[UIColor greenColor];
    //设置进度默认值，这个相当于百分比，范围在0~1之间
    _progress.progress=0;
    //设置进度条上进度的颜色
    _progress.progressTintColor=[UIColor redColor];
    //设置进度条的背景图片
    //    progress.trackImage=[UIImage imageNamed:@"logo.png"];
    //    //设置进度条上进度的背景图片
    //    progress.progressImage=[UIImage imageNamed:@"1.png"];
    [self addSubview:_progress];
    
    _label= [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_progress.frame)+ScreenHeight*60/1334, ScreenWidth, 40)];
    _label.backgroundColor = [UIColor clearColor];
    _label.numberOfLines=2;
    _label.textColor=[UIColor redColor];
    _label.text=@"精彩即将呈现";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:16];
    [self addSubview:_label];

}
//下载成功
- (void)downloadResourcesSuccessful:(NSString *)XMLaddress JSON:(NSString *)JSONaddress model:(NSDictionary *)modelData
{
    [_delegate loadResourcesSuccessful:XMLaddress JSON:JSONaddress model:modelData];
}
//下载失败
- (void)downloadResourcesFailure:(NSString *)errorParameters
{
    NSLog(@"%@",errorParameters);
}

//进度
- (void)theProgressBar:(float)progressValue describe:(NSString *)progressDescribe
{
    NSLog(@"下载 -- %f",progressValue);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_progress setProgress:progressValue animated:YES];
    });
}

//返回
-(void)backBtnClick{

    [_delegate goBack];
}
//刷新
-(void)refreshBtnClick{
    
    [_delegate refreshChanel];

}
@end
