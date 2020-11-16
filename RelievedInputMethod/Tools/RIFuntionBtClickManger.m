//
//  RIFuntionBtClickManger.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/24.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "RIFuntionBtClickManger.h"

@implementation RIFuntionBtClickManger

- (instancetype)manger{
    static dispatch_once_t once  ;
    static RIFuntionBtClickManger *share;
    dispatch_once(&once, ^{
        share =[[RIFuntionBtClickManger alloc]init];
    });
    return share;
}

+(void)showOnScreen:(NSString *)text{
    if ([GetKeyboardStatus status].textDocumentProxy) {
        [[GetKeyboardStatus status].textDocumentProxy insertText:text];
    }
}

@end
