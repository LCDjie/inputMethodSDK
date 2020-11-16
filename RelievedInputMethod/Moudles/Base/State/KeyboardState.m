//
//  KeyboardState.m
//  RelievedInputMethod
//
//  Created by liweijie on 2020/8/27.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "KeyboardState.h"

@implementation KeyboardState


+ (instancetype)shareInstance {
    static KeyboardState * shared;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared =[[KeyboardState alloc]init];
    });
    return shared;
}


@end
