//
//  NIMManager.m
//  NIM
//
//  Created by amao on 11/13/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import "CSSService.h"
#import "CSSSessionUtil.h"

#pragma mark - CSServiceManagerImpl
@interface CSServiceManagerImpl : NSObject
@property (nonatomic,strong)    NSString                *key;
@property (nonatomic,strong)    NSMutableDictionary     *singletons;
@end


@implementation CSServiceManagerImpl

+ (CSServiceManagerImpl *)coreImpl:(NSString *)key
{
    CSServiceManagerImpl *impl = [[CSServiceManagerImpl alloc]init];
    impl.key = key;
    return impl;
}

- (id)init
{
    if (self = [super init])
    {
        _singletons = [[NSMutableDictionary alloc]init];
    }
    return self;
}



- (instancetype)singletonByClass:(Class)singletonClass
{
    NSString *singletonClassName = NSStringFromClass(singletonClass);
    id singleton = [_singletons objectForKey:singletonClassName];
    if (!singleton) {
        singleton = [[singletonClass alloc]init];
        [_singletons setObject:singleton forKey:singletonClassName];
    }
    return singleton;
}

- (void)callSingletonSelector: (SEL)selecotr
{
    NSArray *array = [_singletons allValues];
    for (id obj in array)
    {
        if ([obj respondsToSelector:selecotr])
        {
            SuppressPerformSelectorLeakWarning([obj performSelector:selecotr]);
        }
    }
}

@end

#pragma mark - NIMServiceManager()
@interface CSSServiceManager ()
@property (nonatomic,strong)    NSRecursiveLock *lock;
@property (nonatomic,strong)    CSServiceManagerImpl *core;
+ (instancetype)sharedManager;
- (id)singletonByClass:(Class)singletonClass;
@end

#pragma mark - NIMService
@implementation CSSService
+ (instancetype)sharedInstance
{
    return [[CSSServiceManager sharedManager] singletonByClass:[self class]];
}

- (void)start
{
    DDLogDebug(@"NIMService %@ Started", self);
}
@end

#pragma mark - NIMServiceManager
@implementation CSSServiceManager

+ (instancetype)sharedManager
{
    static CSSServiceManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSSServiceManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callAppWillTerminate)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)start {
    [_lock lock];
    NSString *key = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    _core = [CSServiceManagerImpl coreImpl:key];
    [_lock unlock];
}

- (void)destory {
    [_lock lock];
    [self callSingletonClean];
    _core = nil;
    [_lock unlock];
}

- (id)singletonByClass: (Class)singletonClass
{
    id instance = nil;
    [_lock lock];
    instance = [_core singletonByClass:singletonClass];
    [_lock unlock];
    return instance;
}

#pragma mark - Call Functions
- (void)callSingletonClean
{
    [self callSelector:@selector(onCleanData)];
}


- (void)callReceiveMemoryWarning
{
    [self callSelector:@selector(onReceiveMemoryWarning)];
}


- (void)callEnterBackground
{
    [self callSelector:@selector(onEnterBackground)];
}

- (void)callEnterForeground
{
    [self callSelector:@selector(onEnterForeground)];
}

- (void)callAppWillTerminate
{
    [self callSelector:@selector(onAppWillTerminate)];
}

- (void)callSelector: (SEL)selector
{
    [_core callSingletonSelector:selector];
}


@end
