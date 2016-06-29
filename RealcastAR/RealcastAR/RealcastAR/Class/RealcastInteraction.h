//
//  RCARInteraction.h
//  tianyanAR
//
//  Created by weily on 16/5/12.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#ifndef RealcastInteraction_h
#define RealcastInteraction_h


#define RC_SAFE_OBJFORKEY(dictionary, key , Class) [[dictionary objectForKey:key] isKindOfClass:[Class class]] ? [dictionary objectForKey:key] : nil

/**
 *  说明
 *  本模块用于将interaction json文件中的交互信息与ar界面绑定
 *  根据json文件及后台，本模块将处理对象分为以下数据模型：
 *  AR Projects, AR Scene, AR Element, Event, Action等，
 *  每一个频道号对应为一个project, 同时对应一个json交互数据文件, 
 *  每一个project下有多个场景，每个场景对应一个识别图, 对应数据模型RIScene
 *  每一个场景均可展示多个ar元素，对应数据模型RIARElement
 */

#import "RCARScene.h"
#import "RCInteractionManager.h"
#import "RCWebViewController.h"
#import "RCInteractionManager.h"
#import "RCGestureController.h"

#endif /* RCARInteraction_h */
