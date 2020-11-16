//
//  MenuToolsBar.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/14.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
菜单工具栏
*/

#import <UIKit/UIKit.h>
#import "MenuItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuToolsBar : UIView

//工具栏item需要外部传入，数量不限，可滑动
- (void)configWithItems:(NSArray *)items ;

@end

NS_ASSUME_NONNULL_END
