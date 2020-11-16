//
//  NDBubble.h
//  AXKeyboard
//
//  Created by liweijie on 2020/7/17.
//  Copyright © 2020 芯盾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AXKeyBoardSaseButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface NDBubble : NSObject

+ (UIImageView *)addBubble:(AXKeyBoardSaseButton *)btn targetTitle:(NSString *)tmp;

@end

NS_ASSUME_NONNULL_END
