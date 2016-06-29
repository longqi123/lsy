//
//  ViewController.m
//  RealcastAR
//
//  Created by fish on 16/5/19.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import "ViewController.h"
#import "RCARViewController.h"



@interface ViewController ()<RCARDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"选我选我..." forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
    [btn addTarget:self action:@selector(onClikedToArScene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)onClikedToArScene:(UIButton *)sender {

    RCARViewController *ARvc = [[RCARViewController alloc]init];
    ARvc.otherChanelID = @"3W5qup";//内置频道号
    [self presentViewController:ARvc animated:NO completion:nil];
    
}


#pragma mark -- RCARDelegate
- (void)ARReady:(UIView *)userView {
    // 在此定制UI层
    NSLog(@"定制界面：");
}

@end
