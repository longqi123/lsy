//
//  RCARVideoViewController.m
//  RealcastAR
//
//  Created by lsy on 16/5/24.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import "RCARVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>

@import AVFoundation;
@import AVKit;

@interface RCARVideoViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong)CLGeocoder *geocoder;
@property (nonatomic,strong)CLLocationManager *manager;
@property (nonatomic,copy)NSString *userLocation;

@end

@implementation RCARVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBackBtn];
    NSString *videoStr = [NSString stringWithFormat:@"%@",self.videoUrl];
    NSString *mscStr = [NSString stringWithFormat:@"%@",self.mscUrl];
    
    if (![videoStr isEqualToString:@"(null)"]) {
        
        [self playAV];
       
    }else if (![mscStr isEqualToString:@"(null)"]){
        
        [self LineMSC];
        
    }else{
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.manager requestAlwaysAuthorization];
        [self.manager startUpdatingLocation];
    
    }
}

//在线视频播放
- (void)playAV {
    
    // 获取视频信息
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:self.videoUrl];
    
    // 播放器
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    // 控制器
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    controller.player = player;
    
    [self presentViewController:controller animated:YES completion:^{
        
        [player play];
    }];
    
}

//在线音频播放
- (void)LineMSC{
    // 获取视频信息
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:self.mscUrl];
    
    // 播放器
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    // 控制器
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    controller.player = player;
    
    [self presentViewController:controller animated:YES completion:^{
        
        [player play];
    }];

}
- (void)createBackBtn{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor blackColor]];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];

}
- (void)goBack:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:NO completion:nil];

}
-(CLLocationManager *)manager{
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

//定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    MKPointAnnotation *ann = [[MKPointAnnotation alloc]init];
    CLLocation *loc = [locations firstObject];
    CLGeocoder *gecoder = [[CLGeocoder alloc]init];
    [gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        [self.manager stopUpdatingLocation];//只定位一次
        if (placemarks.count == 0 ||error) {
            NSLog(@"解析失败");
        }else if (placemarks.count>0){
            CLPlacemark *pm = [placemarks firstObject];
            if (pm.locality) {
                ann.title = pm.locality ;
                NSLog(@"local = %@,subtitle = %@,name = %@",pm.locality,pm.subLocality,pm.name);
                self.userLocation = pm.name;
                //导航
                [self userSystemNavigationMapWithDestination];
                ann.subtitle = pm.name;
                
            }else{
                ann.title = pm.administrativeArea;
                ann.subtitle = pm.name;
            }
        }
    }];
}

//传入经纬度导航
-(void)userSystemNavigationMapWithDestination{
    
    [self.geocoder geocodeAddressString:self.userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        MKPlacemark *startPlacemark = [[MKPlacemark alloc]initWithPlacemark:[placemarks firstObject]];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            MKPlacemark *endPlacemark = [[MKPlacemark alloc]initWithPlacemark:[placemarks firstObject]];
            
            /**
             将MKPlaceMark转换成MKMapItem，这样可以放入到item这个数组中
             
             */
            MKMapItem *startItem = [[MKMapItem alloc ] initWithPlacemark:startPlacemark];
            MKMapItem *endItem = [[MKMapItem alloc ] initWithPlacemark:endPlacemark];
            
            NSArray *item = @[startItem ,endItem];
            
            //建立字典存储导航的相关参数
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
            dict[MKLaunchOptionsMapTypeKey] = [NSNumber numberWithInteger:MKMapTypeStandard];
            
            /**
             *调用app自带导航，需要传入一个数组和一个字典，数组中放入MKMapItem，
             字典中放入对应键值
             MKLaunchOptionsDirectionsModeKey   开启导航模式
             MKLaunchOptionsMapTypeKey  地图模式
             MKMapTypeStandard = 0,
             MKMapTypeSatellite,
             MKMapTypeHybrid
             
             // 导航模式
             MKLaunchOptionsDirectionsModeDriving 开车;
             MKLaunchOptionsDirectionsModeWalking 步行;
             */
            
            [MKMapItem openMapsWithItems:item launchOptions:dict];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
