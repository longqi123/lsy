//
//  CSSMeetingNetCallManager.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/24.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CSSMeetingNetCallManager.h"
#import "CSSMeetingRolesManager.h"
#import "CSSBundleSetting.h"

#define NTESNetcallManager [NIMAVChatSDK sharedSDK].netCallManager

@interface CSSMeetingNetCallManager()<NIMNetCallManagerDelegate>
{
    UInt16 _myVolume;
}

@property (nonatomic, strong) NIMNetCallMeeting *meeting;
@property (nonatomic, weak) id<CSSMeetingNetCallManagerDelegate>delegate;

@end

@implementation CSSMeetingNetCallManager

- (void)joinMeeting:(NSString *)name delegate:(id<CSSMeetingNetCallManagerDelegate>)delegate
{
    if (_meeting) {
        [self leaveMeeting];
    }
    
    [NTESNetcallManager addDelegate:self];
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = name;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = [CSSMeetingRolesManager sharedInstance].myRole.isActor;
    
    [self fillNetCallOption:_meeting];
    
    CSSMeetingRole *myRole = [CSSMeetingRolesManager sharedInstance].myRole;
    _meeting.option.videoCaptureParam.startWithCameraOn = myRole.videoOn;
    
    _delegate = delegate;
    
    __weak typeof(self) wself = self;
    
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        if (error) {
            DDLogError(@"Join meeting %@error: %zd.", meeting.name, error.code);
            _meeting = nil;
            if (wself.delegate) {
                [wself.delegate onJoinMeetingFailed:meeting.name error:error];
            }
        }
        else {
            DDLogInfo(@"Join meeting %@ success, ext:%@", meeting.name, meeting.ext);
            _isInMeeting = YES;
            CSSMeetingRole *myRole = [CSSMeetingRolesManager sharedInstance].myRole;
            DDLogInfo(@"Reset mute:%d, camera disable:%d",!myRole.audioOn,!myRole.videoOn);
            [NTESNetcallManager setMute:!myRole.audioOn];
            
            if (wself.delegate) {
                [wself.delegate onMeetingConntectStatus:YES];
            }
            NSString *myUid = [CSSMeetingRolesManager sharedInstance].myRole.uid;
            DDLogInfo(@"Joined meeting.");
            [[CSSMeetingRolesManager sharedInstance] updateMeetingUser:myUid
                                                               isJoined:YES];

        }
    }];

}

- (void)leaveMeeting
{
    if (_meeting) {
        [NTESNetcallManager leaveMeeting:_meeting];
        _meeting = nil;
    }
    [NTESNetcallManager removeDelegate:self];
    _isInMeeting = NO;
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ joined meeting", uid);
    if ([meeting.name isEqualToString:_meeting.name]) {
        [[CSSMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:YES];
    }
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ left meeting", uid);

    if ([meeting.name isEqualToString:_meeting.name]) {
        [[CSSMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:NO];
    }
}

- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"meeting error %zd", error.code);
    _isInMeeting = NO;
    [_delegate onMeetingConntectStatus:NO];
}



- (void)onMyVolumeUpdate:(UInt16)volume
{
    _myVolume = volume;    
}

- (void)onSpeakingUsersReport:(nullable NSArray<NIMNetCallUserInfo *> *)report
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];

    NSMutableDictionary *volumes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self volumeLevel:_myVolume], myUid, nil];

    for (NIMNetCallUserInfo *info in report) {
        [volumes setObject:[self volumeLevel:info.volume] forKey:info.uid];
    }
    
    [[CSSMeetingRolesManager sharedInstance] updateVolumes:volumes];
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
{
    DDLogInfo(@"Net status of %@ is %zd", user, status);
}

#pragma mark - private
- (void)fillNetCallOption:(NIMNetCallMeeting *)meeting
{
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    
    option.videoCrop = [[CSSBundleSetting sharedConfig] videochatVideoCrop];
    option.autoRotateRemoteVideo = [[CSSBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[CSSBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[CSSBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[CSSBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[CSSBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[CSSBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.autoDeactivateAudioSession = [[CSSBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[CSSBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[CSSBundleSetting sharedConfig] voiceDetect];
    option.preferHDAudio = [[CSSBundleSetting sharedConfig] preferHDAudio];
    option.videoCaptureParam = [self videoCaptureParam];
    _meeting.option = option;
}

- (NIMNetCallVideoCaptureParam *)videoCaptureParam
{
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
    param.startWithBackCamera   = [[CSSBundleSetting sharedConfig] startWithBackCamera];

    param.preferredVideoQuality = [[CSSBundleSetting sharedConfig] preferredVideoQuality];
    BOOL isManager = [CSSMeetingRolesManager sharedInstance].myRole.isManager;
    
    //会议的观众这里默认用低清发送视频
    if (param.preferredVideoQuality == NIMNetCallVideoQualityDefault) {
        if (!isManager) {
            param.preferredVideoQuality = NIMNetCallVideoQualityLow;
        }
    }
    return param;
}



-(NSNumber *)volumeLevel:(UInt16)volume
{
    int32_t volumeLevel = 0;
    volume /= 40;
    while (volume > 0) {
        volumeLevel ++;
        volume /= 2;
    }
    if (volumeLevel > 8) volumeLevel = 8;
    
    return @(volumeLevel);
}

@end
