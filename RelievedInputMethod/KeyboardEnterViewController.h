//
//  KeyboardEnterViewController.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*   自定义键盘入口，主要用于切换键盘
*/


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardEnterViewController : UIViewController

@property(nonatomic, strong) NSArray * itemArray ;

- (void)addViewInMenuBottom:(UIView *)view; //在菜单栏下添加界面
- (void)removeMenuBottomView;//移除菜单栏下界面
- (void)addViewInMenuTop:(UIView *)view;//在菜单栏上面添加界面
- (void)removeMenuTopView ;//移除菜单栏上面的界面
- (void)addSwitchKeyboard; //键盘界面
- (void)removeSwitchKeyboard; //移除键盘界面
- (void)refreshView;
@end

NS_ASSUME_NONNULL_END
