//
//  NineRightSide.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/17.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
拼音，数字九键右侧栏View
*/

#import <UIKit/UIKit.h>
#import "BaseModuleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NineRightSide : BaseModuleView

//展示的item从外部传入
- (instancetype)initWithItems:(NSArray *)items;
@end

NS_ASSUME_NONNULL_END
