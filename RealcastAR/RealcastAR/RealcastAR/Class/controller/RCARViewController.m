//
//  RCARViewController.m
//  ProjectTemplet
//
//  Created by fish on 16/4/22.
//  Copyright © 2016年 huangtao. All rights reserved.
//

#import "RCARViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RealcastInteraction.h"
#import "RCARVideoViewController.h"
#import "RCCustomAnimation.h"
#import "RCARView.h"
#import "RCARProject.h"
#import "RCMediaDynamicLoader.h"
#import "RCARLoadDataView.h"

//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface RCARViewController ()<SDKReadyCallbackDelegate, TrackingStatusCallbackDelegate,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,MatchingCallbackDelegate,arcViewBtnDelegate,RCARLoadDataViewDelegare>
{
   
    /**
     *  默认的手势管理器，对当前识别图的所有模型进行设置
     */
    RCGestureController *_rotateGesture;
    RCGestureController *_translateGesture;
    RCGestureController *_scaleGesture;
    RCARLoadDataView *_progressView;//进度条 view
    AVCaptureDevice      *_device;   //手电筒
}

/**
 *  AR
 */
@property (nonatomic, strong) RXSDKInterface *sdkInterface;
@property (nonatomic, assign) int modelIndex;
@property (nonatomic, strong) RCARProject          *arProject;
@property (nonatomic, strong) RCInteractionManager *interactionManager;
@property (nonatomic, strong) RCMediaDynamicLoader *dynamicLoader;

@end

@implementation RCARViewController

- (void)dealloc {
    
    NSLog(@"dealloced...");
}

#pragma mark -- 声明周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.otherChanelID && !self.xmlPath) {
        [self downloadView];//下载资源  加载页
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initRXAR];
            [self startPreview];
            [self startAR];
        });
        
    }
}
- (void)downloadView{
    //放进度条的 view
    _progressView = [[RCARLoadDataView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) chanelID:_otherChanelID];;
    _progressView.delegate = self;
    _progressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_progressView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark -- 界面初始化
- (void)initUserInterface {
    
    [self.view setUserInteractionEnabled:YES];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(ScreenWidth*24/750, ScreenHeight*40/1334, ScreenWidth*50/750, ScreenWidth*50/750);
    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sdkInterface.contentView addSubview:backBtn];
    
    //刷新按钮
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(ScreenWidth-ScreenWidth*74/750, ScreenHeight*40/1334, ScreenWidth*50/750, ScreenWidth*50/750);
    [refreshBtn setImage:[UIImage imageNamed:@"iconfont-xuanzhuanjiantou"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sdkInterface.contentView addSubview:refreshBtn];
    
    //下面的一排按钮
    RCARView *rcarView = [[RCARView alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth*90/750, ScreenHeight-ScreenWidth*74/750, ScreenWidth, ScreenWidth*74/750)];
    
    rcarView.tagDelegate = self;
    [self.sdkInterface.contentView addSubview:rcarView];
    
    //初始化手电筒
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
}
//加载成功进度条回调
-(void)loadResourcesSuccessful:(NSString *)XMLaddress JSON:(NSString *)JSONaddress model:(NSDictionary *)modelData{
    
    self.xmlPath = XMLaddress;
    self.jsonfile = JSONaddress;
    self.mediaDic = modelData;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _progressView.hidden = YES;
        [self initRXAR];
        [self startPreview];
        [self startAR];
    });
}
//加载页返回
-(void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:nil];

}
//加载页刷新频道
-(void)refreshChanel{

    [self downloadView];
}
//返回
-(void)backBtnClick{
    [self stopAR];
    [self stopPreview];
    self.sdkInterface.matchingCallbackDelegate = nil;
    self.sdkInterface.sdkReadyCallbackDelegate = nil;
    self.sdkInterface.trackingStatusCallbackDelegate = nil;
    self.sdkInterface = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
//刷新
-(void)refreshBtnClick{
    [self stopPreview];
    [self stopAR];
    [self.view removeFromSuperview];
    [self downloadView];
}
#pragma mark -- AR相关
- (void)initRXAR {
    // 初始化AR SDK
    self.sdkInterface = [[RXSDKInterface alloc] init];
    [self.sdkInterface verify:@"16A21-13876-2D9CD-D2301-7FDF6"];
    self.sdkInterface.sdkReadyCallbackDelegate = self;
    self.sdkInterface.trackingStatusCallbackDelegate = self;
    self.sdkInterface.matchingCallbackDelegate = self;
    self.sdkInterface.contentView.userInteractionEnabled = YES;
    
    //加载 xml
    BOOL isLoadFile = [self.sdkInterface loadConfigFile:self.xmlPath];
    if (!isLoadFile) {
        NSLog(@"资源未加载成功!");
    }
    
    //  加载ar配置
    self.arProject = [[RCARProject alloc] initWithDictionary:[self arInformations]];
    //  设置交互处理器
    _interactionManager = [[RCInteractionManager alloc] initWithARProject:_arProject];
    //  设置动态加载器
    if (_mediaDic) {
        _dynamicLoader = [RCMediaDynamicLoader dynamicLoaderForProject:_arProject];
        [_dynamicLoader addDynamciLoadInfos:_mediaDic];
    }
}
- (NSDictionary *)arInformations
{
    //加载 json
    NSData *jsondata = [NSData dataWithContentsOfFile:self.jsonfile];
    if (jsondata) {
        id json = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:nil];
        return json;
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    
    [self.sdkInterface processTouchesBeganEvent:touches withEvent:event];
   
    self.modelIndex = -1;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    [self.sdkInterface processTouchesEndedEvent:touches withEvent:event];
    
    
    /*NSLog(@"TTTTTTT Position (%d,%d), %d Combo Touchs , %d Fingers.\n",
     self.sdkInterface->m_TouchInfo.location_X,
     self.sdkInterface->m_TouchInfo.location_Y,
     self.sdkInterface->m_TouchInfo.tapCount,
     self.sdkInterface->m_TouchInfo.fingerCount);*/
    //NSLog(@"tracked id is %i",self.sdkInterface->m_ARTrackedID);
    /*NSLog(@"X is %f, Y is %f, Z is %f.\n",
     self.sdkInterface->m_ScaleInfo.x,
     self.sdkInterface->m_ScaleInfo.y,
     self.sdkInterface->m_ScaleInfo.z);*/
    //[self.sdkInterface setScale:self.sdkInterface->m_ARTrackedID X:3 Y:3 Z:3];
}

#pragma mark -- AR操作自定义方法
- (void)startPreview
{
    int returnInt = [self.sdkInterface startPreview:self];
    NSLog(@"startPreview returnInt: %d", returnInt);
}

- (void)stopPreview
{
    int returnInt = [self.sdkInterface stopPreview];
    NSLog(@"stopPreview returnInt: %d", returnInt);
}

- (void)startAR
{
    int returnInt = [self.sdkInterface startAR];
    NSLog(@"startAR returnInt: %d", returnInt);
}

- (void)stopAR
{
    int returnInt = [self.sdkInterface stopAR];
    NSLog(@"stopAR returnInt: %d", returnInt);
}

- (void)startMatching
{
    int returnInt = [self.sdkInterface startMatching:@"channel1"];
    NSLog(@"startMatching returnInt: %d", returnInt);
}

- (void)stopMatching
{
    int returnInt = [self.sdkInterface stopMatching];
    NSLog(@"stopMatching returnInt: %d", returnInt);
}

//拍照 。 截屏
-(void)capture
{
    [self.sdkInterface takeScreenShot];
}

-(void)switchcamera
{
    [self.sdkInterface switchCamera];
}

- (void)reload {
    // 处理刷新逻辑
}

#pragma mark -- 代理方法
#pragma mark -- sdkReadyCallbackDelegate
- (void)SDKReady {
    NSLog(@"SDK准备就绪!");
    
    [self initUserInterface];
    
    //将预先加载的模型遍历写入内存便于扫描识别图直接出模型
    for (NSString *trackableID in self.mediaDic) {
        
        for (NSString *mediaID in [self.mediaDic objectForKey:trackableID]) {
            
            [self.sdkInterface loadModelTrackableID:[trackableID intValue] mediaID:mediaID];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ARReady:)]) {
        // 清除掉view上的所有内容，避免重复
//        NSArray *views = [self.sdkInterface.contentView subviews];
//        for (UIView *view in views) {
//            [view removeFromSuperview];
//        }
        
        [self.delegate ARReady:self.sdkInterface.contentView];
    }
}

#pragma mark -- TrackingStatusCallbackDelegate

-(void)mediaTouchedTrackableID:(int)trackableID modelIndex:(int)modelIndex actionID:(int)actionID
{
    
    self.modelIndex = modelIndex;
    
    [self triggerEvent:trackableID mediaIndex:modelIndex type:RCEventTypeClick];

}

-(void)tracking
{
//    NSLog(@"is tracking");
}

-(void)tracked:(int)trackableID
{
    if ([_dynamicLoader trackableIsDynamicLoad:trackableID]) {
        [_dynamicLoader loadDatasetWithID:trackableID callback:^(Dataset *dataset) {
            
        }];
    }
    
    ///	处理该识别图下的通用事件
    __weak typeof(self) weakSelf = self;
    [_interactionManager trigerEvent:trackableID type:RCEventTypeTracking withAction:^(RCAction *action) {
        [weakSelf handleAction:action];
    }];
    
    if (!_scaleGesture) {
        __weak typeof(self) weakSelf = self;
        _scaleGesture = [[RCGestureController alloc] initWithTarget:self.sdkInterface.contentView eventBegin:^RCTransform *
                         {
                             if (weakSelf.modelIndex != -1) {
                                 RCARElement *ar = [weakSelf.interactionManager arElementWithTrackID:weakSelf.sdkInterface->m_ARTrackedID modelIndex:weakSelf.modelIndex];
                                 if (ar.gesture.scale) {
                                     NSArray *scales = [weakSelf.sdkInterface getScale:weakSelf.sdkInterface->m_ARTrackedID
                                                                            mediaIndex:weakSelf.modelIndex];
                                     return [RCTransform transformWithArray:scales];
                                 }
                             }
                             return nil;
                         } eventCallback:^(RCTransform *transformBegin, RCTransform *transform)
                         {
                             if (weakSelf.modelIndex != -1) {
                                 [weakSelf.sdkInterface setScale:weakSelf.sdkInterface->m_ARTrackedID mediaIndex:weakSelf.modelIndex
                                                           scale:transform.transformArray];
                                 //  触发缩放事件
                                 [weakSelf triggerEvent:weakSelf.sdkInterface->m_ARTrackedID
                                             mediaIndex:weakSelf.modelIndex
                                                   type:RCEventTypeScaled];
                             }
                         }];
        [_scaleGesture arEventScaleGesture];
    }
    if (!_translateGesture) {
        __weak typeof(self) weakSelf = self;
        _translateGesture = [[RCGestureController alloc] initWithTarget:weakSelf.sdkInterface.contentView eventBegin:^RCTransform *{
            if (weakSelf.modelIndex != -1) {
                RCARElement *ar = [weakSelf.interactionManager arElementWithTrackID:weakSelf.sdkInterface->m_ARTrackedID
                                                                         modelIndex:weakSelf.modelIndex];
                if (ar.gesture.transition) {
                    NSArray *translate = [weakSelf.sdkInterface getTranslate:weakSelf.sdkInterface->m_ARTrackedID
                                                                  mediaIndex:weakSelf.modelIndex];
                    return [RCTransform transformWithArray:translate];
                }
                
            }
            return nil;
        } eventCallback:^(RCTransform *transformBegin, RCTransform *transform) {
            if (weakSelf.modelIndex != -1) {
                NSArray *translated = [transform transformArray];
                [weakSelf.sdkInterface setTranslate:weakSelf.sdkInterface->m_ARTrackedID
                                         mediaIndex:weakSelf.modelIndex
                                                pos:translated];
                
                //  触发移动事件
                [weakSelf triggerEvent:weakSelf.sdkInterface->m_ARTrackedID
                            mediaIndex:weakSelf.modelIndex
                                  type:RCEventTypeTranslated];
            }
        }];
        [_translateGesture arEventPanGesture];
    }
    if (!_rotateGesture) {
        __weak typeof(self) weakSelf = self;
        _rotateGesture = [[RCGestureController alloc] initWithTarget:weakSelf.sdkInterface.contentView eventBegin:^RCTransform *{
            if (weakSelf.modelIndex != -1) {
                RCARElement *ar = [weakSelf.interactionManager arElementWithTrackID:weakSelf.sdkInterface->m_ARTrackedID
                                                                         modelIndex:weakSelf.modelIndex];
                if (ar.gesture.rotation) {
                    NSArray *rotate = [weakSelf.sdkInterface getEulerRotation:weakSelf.sdkInterface->m_ARTrackedID mediaIndex:weakSelf.modelIndex];
                    
                    return [RCTransform transformWithArray:rotate];
                }
            }
            return nil;
        } eventCallback:^(RCTransform *transformBegin, RCTransform *transform) {
            if (weakSelf.modelIndex != -1) {
                [self.sdkInterface setEulerRotation:weakSelf.sdkInterface->m_ARTrackedID mediaIndex:weakSelf.modelIndex eulerRotation:transform.transformArray];
                
                //  触发旋转事件
                [weakSelf triggerEvent:weakSelf.sdkInterface->m_ARTrackedID
                            mediaIndex:weakSelf.modelIndex
                                  type:RCEventTypeRotated];
            }
        }];
        [_rotateGesture arEventRotationGesture];
    }

}

-(void)lost:(int)trackableID
{
    __weak typeof(self) weakSelf = self;
    [_interactionManager trigerEvent:trackableID type:RCEventTypeLostTracking withAction:^(RCAction *action) {
        [weakSelf handleAction:action];
    }];
}

-(void)loadProgress:(float)rateOfProgress{
    NSLog(@"rate of progress is %f",rateOfProgress);
}

-(void)screenCaptured:(UIImage *)image{
    NSLog(@"截屏");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenCaptured:)]) {
        [self.delegate screenCaptured:image];
    }
}

-(void)animationStartStateTrackableID:(int)trackableID modelIndex:(int)modelIndex
{
    [self triggerEvent:trackableID mediaIndex:modelIndex type:RCEventTypeAnimationStart];
}
-(void)animationStopStateTrackableID:(int)trackableID modelIndex:(int)modelIndex
{
    [self triggerEvent:trackableID mediaIndex:modelIndex type:RCEventTypeAnimationEnded];
}
-(void)animationPauseStateTrackableID:(int)trackableID modelIndex:(int)modelIndex
{
    [self triggerEvent:trackableID mediaIndex:modelIndex type:RCEventTypeAnimationPause];
}
-(void)movieStartStateTrackableID:(int)trackableID modelIndex:(int)modelIndex
{
    [self triggerEvent:trackableID mediaIndex:modelIndex type:RCEventTypeMovieStarted];
}
-(void)movieStopStateTrackableID:(int)trackableID modelIndex:(int)modelIndex
{
    [self triggerEvent:trackableID mediaIndex:modelIndex type:RCEventTypeMovieEnded];
}
-(void)moviePauseStateTrackableID:(int)trackableID modelIndex:(int)modelIndex
{
    [self triggerEvent:trackableID mediaIndex:modelIndex type:RCEventTypeMoviePause];
}

-(void)getAnimationChannelSize
{
    
    unsigned long no = [self.sdkInterface getAnimationChannelSize:self.sdkInterface->m_ARTrackedID mediaIndex:0];
    
    NSLog(@"no is %lu",no);
}

//cameraPosition Callback++++++++++++++++++++++++++++++Tsun
-(void)cameraPositionTranslateX:(float)translate_x
                     TranslateY:(float)translate_y
                     TranslateZ:(float)translate_z
                      RotationX:(float)rotation_x
                      RotationY:(float)rotation_y
                      RotationZ:(float)rotation_z{
    /*NSLog(@"cameraPosition: \nTranslateX:%f \nTranslateY:%f \nTranslateZ:%f",
     translate_x,
     translate_y,
     translate_z);*/
    
    /*NSLog(@"cameraPosition: \nRotationX:%f, \nRotationY:%f \nRotationZ:%f",
     rotation_x,
     rotation_y,
     rotation_z);*/
}

#pragma mark -- MatchingCallbackDelegate
-(void)matchingCallback:(bool)match withIdentifier:(NSString*)identifier withMetadata:(NSString*)metadata
{
    NSLog(@"image identifier is %@",identifier);
}

/// 新增，动作触发
- (void)triggerEvent:(int)trackId mediaIndex:(int)midx type:(RCEventType)type
{
    __weak typeof(self) weakSelf = self;
    [_interactionManager triggerEvent:trackId mediaIndex:midx type:type withAction:^(RCAction *action) {
        [weakSelf handleAction:action];
    }];
}

- (void)handleAction:(RCAction *)action
{
    switch (action.actionType)
    {
        case RCActionTypeHttps:
        case RCActionTypeHttp: {
            //打开网页
            RCWebViewController *vc = [[RCWebViewController alloc] init];
            vc.linkURL = action.value[0];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            UIViewController *arcontroller = (UIViewController *)self.sdkInterface->m_ARViewController;
            
            [arcontroller presentViewController:nav animated:YES completion:nil];
            break;
        }
        case RCActionTypeVisibility: {
            //设置显示或隐藏
            
            RIVisibilityActionParameters *param = (id)action.parameters;
            BOOL show = [param.type isEqualToString:@"show"];
            
            NSString *target = action.value[0];
            
            int trackid,mediaid;
            
            [_interactionManager getTrackID:&trackid mediaID:&mediaid withName:target];
            [self.sdkInterface setVisibility:show trackableID:(int)trackid mediaIndex:(int)mediaid];
            
            break;
        }
        case RCActionTypeTel: {
            ///	打电话事件
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",action.value[0]]]];
            break;
        }
        case RCActionTypeSms: {
            ///	发短信
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",action.value[0]]]];
            break;
        }
        case RCActionTypeMailTo: {
            ///	发邮件
            if (![MFMailComposeViewController canSendMail]) {
                // 提示用户设置邮箱
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请设置自己邮箱号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc]init];
            //主题
            [controller setSubject:@"啦啦啦"];
            //收件人
            [controller setToRecipients:action.value[0]];
            //正文
            [controller setMessageBody:@"这是我这周的工作周报.........." isHTML:NO];
        
            [self presentViewController:controller animated:YES completion:nil];
            
            break;
        }
        case RCActionTypeOnlineVideo: {
            ///	播放在线视频 
            NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",action.value[0]]];
            RCARVideoViewController *vc = [[RCARVideoViewController alloc] init];
            vc.videoUrl = videoURL;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *arcontroller = (UIViewController *)self.sdkInterface->m_ARViewController;
            [arcontroller presentViewController:nav animated:YES completion:nil];

            break;
        }
        case RCActionTypeSound: {
            ///	点击播放音频
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",action.value[0]]];
            RCARVideoViewController *vc = [[RCARVideoViewController alloc] init];
            vc.mscUrl = url;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *arcontroller = (UIViewController *)self.sdkInterface->m_ARViewController;
            [arcontroller presentViewController:nav animated:YES completion:nil];

            break;
        }
        case RCActionTypeRoute: {
            ///	定位导航
            CGFloat valueLongtitude = [action.value[0] floatValue];
            CGFloat valueAtitude = [action.value[1] floatValue];
            RCARVideoViewController *vc = [[RCARVideoViewController alloc] init];
            vc.longitude = valueLongtitude;
            vc.latitude = valueAtitude;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            UIViewController *arcontroller = (UIViewController *)self.sdkInterface->m_ARViewController;
            [arcontroller presentViewController:nav animated:YES completion:nil];
            
            break;
        }
        case RCActionTypeARVideo: {
            ///	AR视频
            int tracking, media;
            [_interactionManager getTrackID:&tracking mediaID:&media withName:action.value[0]];
            
            NSString *type = action.parameters[@"type"];
            if ([type isEqualToString:@"start"]) {
                
                 [self.sdkInterface startMovie:tracking mediaIndex:media];
                
            }else if ([type isEqualToString:@"pause"]){
                
                [self.sdkInterface pauseMovie:tracking mediaIndex:media];
                
            }else{
                [self.sdkInterface stopMovie:tracking mediaIndex:media];
            }
        
            break;
        }
        case RCActionTypeEffect: {
            ///	自定义动画
            NSString *arname = action.value[0];
            int tracking, media;
            [_interactionManager getTrackID:&tracking mediaID:&media withName:arname];
            //起始位置
            RCTransform *startRotation = [[RCTransform alloc]initWithDictionary:action.parameters[@"start"][@"rotation"]];
            RCTransform *startScale = [[RCTransform alloc]initWithDictionary:action.parameters[@"start"][@"scale"]];
            RCTransform *startTranslate = [[RCTransform alloc]initWithDictionary:action.parameters[@"start"][@"translate"]];
            
            //结束位置
            RCTransform *endRotation = [[RCTransform alloc]initWithDictionary:action.parameters[@"end"][@"rotation"]];
            RCTransform *endScale = [[RCTransform alloc]initWithDictionary:action.parameters[@"end"][@"scale"]];
            RCTransform *endTranslate = [[RCTransform alloc]initWithDictionary:action.parameters[@"end"][@"translate"]];
            
            //动画时间
            CGFloat duration = [action.parameters[@"duration"] floatValue];
            
            //动画类型
            NSString *animationType = [NSString stringWithFormat:@"%@",action.parameters[@"tween"]];
            
            //动画类型到枚举的映射
            NSDictionary *animationTypeMapping = @{@"ANIM_TYPE_LINEAR": @(ANIM_TYPE_LINEAR),
                                                   @"ANIM_TYPE_QUAD": @(ANIM_TYPE_QUAD),
                                                   @"ANIM_TYPE_CUBIC": @(ANIM_TYPE_CUBIC),
                                                   @"ANIM_TYPE_QUART": @(ANIM_TYPE_QUART),
                                                   @"ANIM_TYPE_QUINT": @(ANIM_TYPE_QUINT),
                                                   @"ANIM_TYPE_SINE": @(ANIM_TYPE_SINE),
                                                   @"ANIM_TYPE_CIRC": @(ANIM_TYPE_CIRC),
                                                   @"ANIM_TYPE_EXPO": @(ANIM_TYPE_EXPO),
                                                   @"ANIM_TYPE_BOUNCE": @(ANIM_TYPE_BOUNCE),
                                                   };
            
            //动画参数赋值
            RCCustomAnimation *animation = [[RCCustomAnimation alloc] init];
            animation.transformTranslateBegin = startTranslate;
            animation.transformRotateBegin = startRotation;
            animation.transformScaleBegin  = startScale;
            animation.transformTranslateEnd = endTranslate;
            animation.transformScaleEnd = endScale;
            animation.transformRotateEnd = endRotation;
            animation.duration = duration;
            animation.animationType = [animationTypeMapping[animationType] integerValue];
            
            //开始执行动画
            animation.animationCallback = ^(RCTransform *translate, RCTransform *rotate, RCTransform *scale) {
                
                NSArray *scaleArr = @[[NSNumber numberWithFloat:scale.x],[NSNumber numberWithFloat:scale.y],[NSNumber numberWithFloat:scale.z]];
                NSArray *translateArr = @[[NSNumber numberWithFloat:translate.x],[NSNumber numberWithFloat:translate.y],[NSNumber numberWithFloat:translate.z]];
                NSArray *rotateArr = @[[NSNumber numberWithFloat:rotate.x],[NSNumber numberWithFloat:rotate.y],[NSNumber numberWithFloat:rotate.z]];
                
                [self.sdkInterface setScale:tracking mediaIndex:media scale:scaleArr];
                [self.sdkInterface setTranslate:tracking mediaIndex:media pos:translateArr];
                [self.sdkInterface setEulerRotation:tracking mediaIndex:media eulerRotation:rotateArr];
            };
            animation.animationEnd = ^(){
                NSLog(@"动画结束");
            };
            
            [animation startAnimation];
        
            break;
        }
        case RCActionTypeAnimate: {
            ///	模型动画控制
            NSString *arname = action.value[0];
            int loop = [action.parameters[@"loop"] intValue];//是否循环
            int tracking, media;
            [_interactionManager getTrackID:&tracking mediaID:&media withName:arname];
            NSString *type = action.parameters[@"type"];
            
            if ([type isEqualToString:@"start"]) {
                
                [self.sdkInterface startAnimation:tracking mediaIndex:media animationName:action.parameters[@"animationName"] loopNo:loop];
                
            }else if ([type isEqualToString:@"pause"]){
                
                [self.sdkInterface pauseAnimation:tracking mediaIndex:media];
                
            }else{
                
                [self.sdkInterface stopAnimation:tracking mediaIndex:media];
            }

            break;
        }
        case RCActionTypeChannels: {
            /// 打开别的频道
            _otherChanelID = action.value[0];
            [self stopPreview];
            [self stopAR];
            self.sdkInterface = nil;
            [self.view removeFromSuperview];
            [self downloadView];

            break;
        }
        case RCActionTypeHtml: {
            /// 图文信息
            RCWebViewController *vc = [[RCWebViewController alloc] init];
            vc.linkURL = action.value[0];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            UIViewController *arcontroller = (UIViewController *)self.sdkInterface->m_ARViewController;
            
            [arcontroller presentViewController:nav animated:YES completion:nil];

            break;
        }

        default:
            break;
    }
}
#pragma mark - 发邮件的回调
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 根据不同状态提示用户
    /**
     MFMailComposeResultCancelled,      取消
     MFMailComposeResultSaved,          保存邮件
     MFMailComposeResultSent,           已经发送
     MFMailComposeResultFailed          发送失败
     */
    NSLog(@"%d", result);
    if (result == MFMailComposeResultCancelled) {
        NSLog(@"邮件取消");
    }else if (result == MFMailComposeResultFailed) {
        NSLog(@"邮件发送失败");
    }else if (result == MFMailComposeResultSent) {
        NSLog(@"邮件发送成功");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//最下边按钮点击事件
-(void)btnclick:(int)tag{

    if (tag == 10001) {//截屏
        [self capture];
    }
    if (tag == 10002) {//手电筒
        [self flashlightEvent];
    }
    if (tag == 10003) {//分享
        
        
    }if (tag == 10004) {//收藏
        
        
    }
}

//手电筒
- (void)flashlightEvent
{
    static int i = 0;
    if (i%2) {
        i ++;
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device unlockForConfiguration];
    }
    //关闭手电筒
    else
    {
        i ++;
        [_device lockForConfiguration:nil];
        [_device setTorchMode: AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
    }
}


@end
