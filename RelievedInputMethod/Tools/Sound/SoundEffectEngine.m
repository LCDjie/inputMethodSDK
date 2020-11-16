//
//  SoundEffectEngine.m
//  NiudunInputMethod
//
//  Created by wei on 2018/12/21.
//  Copyright © 2018年 芯盾. All rights reserved.
//

#import "SoundEffectEngine.h"
//#import "NDAppGroupManager.h"
#import <AudioToolbox/AudioToolbox.h>

#define SOUNDID 1104//点击音效

@implementation SoundEffectEngine

+ (void)play {
    AudioServicesPlaySystemSoundWithCompletion(1104, nil);//声音

    /*
    NSDictionary *settings = [NDAppGroupManager getKeyboardSetting];
    if (settings) {
        BOOL keyVoice = [[settings objectForKey:@"keyVolume"] boolValue];//声音
//        BOOL keyShake = [[settings objectForKey:@"keyBubble"] floatValue];
//        UIImpactFeedbackStyle FeedbackStyle;
//        if (keyShake) {
//            if (keyShake <= 0.34) {
//                FeedbackStyle = UIImpactFeedbackStyleLight;
//            } else if ( 0.34 < keyShake < 0.67 ){
//                FeedbackStyle = UIImpactFeedbackStyleMedium;
//            } else {
//                FeedbackStyle = UIImpactFeedbackStyleHeavy;
//            }
//            //震动
//            if (@available(iOS 10.0, *)) {
//                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
//                [feedBackGenertor impactOccurred];
//            }
//        }
        
        if (keyVoice) {
            AudioServicesPlaySystemSoundWithCompletion(1104, nil);//声音
        }
    } else {
        AudioServicesPlaySystemSoundWithCompletion(1104, nil);//声音
    }
    
//    AudioServicesPlaySystemSoundWithCompletion(1520, ^{ });iphone7一下设备,私有api

//    // 普通短震，3D Touch 中 Peek 震动反馈
//    AudioServicesPlaySystemSound(1519);
//    // 普通短震，3D Touch 中 Pop 震动反馈
//    AudioServicesPlaySystemSound(1520);
//    // 连续三次短震
//    AudioServicesPlaySystemSound(1521);
     */
}

@end
