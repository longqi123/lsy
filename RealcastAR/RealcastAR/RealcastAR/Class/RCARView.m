//
//  RCARView.m
//  RealcastAR
//
//  Created by Steven2761 on 16/6/1.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import "RCARView.h"

//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation RCARView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self createUI];
    
    return self;
}

-(void)createUI{
    
    //最下方的五个按钮
    NSArray *imgArr = @[@"jiantou_back",@"iconfont-xiangji",@"iconfont-shoudiantong",@"iconfont-fenxiang",@"iconfont-shoucang (1)",@"jiantou"];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth*24/750 + i * ScreenWidth*163/750, 0 , ScreenWidth*50/750, ScreenWidth*50/750);
        btn.tag = 10000 + i;
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:btn];
        
    }
}

-(void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 10000:{
            static int i = 1;
            if (i%2) {
                i ++;
                [UIView animateWithDuration:0.5 animations:^{
                    self.frame = CGRectMake(0,ScreenHeight-ScreenWidth*74/750,ScreenWidth,ScreenWidth*74/750);
                }];
                UIButton *but = (UIButton *)[self viewWithTag:10000];
                [but setImage:[UIImage imageNamed:@"jiantou"] forState:(UIControlStateNormal)];
            }
            else{
                i ++;
                [UIView animateWithDuration:0.5 animations:^{
                    self.frame = CGRectMake(ScreenWidth-ScreenWidth*90/750,ScreenHeight-ScreenWidth*74/750,ScreenWidth,ScreenWidth*74/750);
                }];
                UIButton *but = (UIButton *)[self viewWithTag:10000];
                [but setImage:[UIImage imageNamed:@"jiantou_back"] forState:(UIControlStateNormal)];
               }
            
            }
         
            break;
        case 10001:{
            
            [self.tagDelegate btnclick:10001];
        }
            
            break;
        case 10002:{
        
            [self.tagDelegate btnclick:10002];
        }
            
            break;
        case 10003:{
        
            [self.tagDelegate btnclick:10003];
        }
        
            break;
        case 10004:{
        
            [self.tagDelegate btnclick:10004];
        }
            
            break;
        default:
            break;
    }


}
@end
