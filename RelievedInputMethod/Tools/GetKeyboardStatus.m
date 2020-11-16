//
//  GetKeyboardStatus.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "GetKeyboardStatus.h"

@implementation GetKeyboardStatus

+ (instancetype)status {
    static GetKeyboardStatus * shared;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared =[[GetKeyboardStatus alloc]init];
    });
    return shared;
}

+ (BOOL)isFristLaunch {
    //未设置情况下默认是第一次启动
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ DEFAULTS_FIRST_LAUNCH_KEY: @(YES), }];
    BOOL firstLaunch = [[[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTS_FIRST_LAUNCH_KEY] boolValue];
    if (firstLaunch) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:DEFAULTS_FIRST_LAUNCH_KEY];
    }
    return firstLaunch;
}

- (void)setCurrentKeyboardType:(KeyboardType)currentKeyboardType {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"KeyboardType_Current": [NSString stringWithFormat:@"%d",2], }];

    
    NSString * typeStr =[NSString stringWithFormat:@"%d",(int)currentKeyboardType];
    [[NSUserDefaults standardUserDefaults]setObject:typeStr forKey:@"KeyboardType_Current"];
}

- (KeyboardType)currentKeyboardType {
    //注册
      
    NSString * currentTy =[[NSUserDefaults standardUserDefaults]objectForKey:@"KeyboardType_Current"];
    if ([currentTy intValue] >9 || [currentTy intValue] <0 ) {
        return (KeyboardType)2;
    }
    return (KeyboardType)[currentTy intValue];
}

- (void)setLastKeyboardType:(KeyboardType)lastKeyboardType {
     [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"KeyboardType_last": [NSString stringWithFormat:@"%d",2], }];
    
    NSString * typeStr =[NSString stringWithFormat:@"%d",(int)lastKeyboardType];
    [[NSUserDefaults standardUserDefaults]setObject:typeStr forKey:@"KeyboardType_last"];
}

- (KeyboardType)lastKeyboardType {
  
    NSString * currentTy =[[NSUserDefaults standardUserDefaults]objectForKey:@"KeyboardType_last"];
    
    if ([currentTy intValue] >9 || [currentTy intValue] <0 ) {
        return (KeyboardType)2; //默认是拼音9键
    }
    NSLog(@"wwwwwwwwwww%d",[currentTy intValue]);
    return (KeyboardType)[currentTy intValue];
    
}

@end
