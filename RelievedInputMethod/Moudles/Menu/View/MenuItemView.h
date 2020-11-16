//
//  MenuItemView.h
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/14.
//  Copyright © 2020 靳翠翠. All rights reserved.
//
/*
菜单栏item
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuItemView : UIButton

//item为标题样式
- (instancetype)initWithTitle:(NSString *)title;

//item为图片样式
- (instancetype)initWithImage:(NSString *)image selectImage:(NSString *)selectImage;

//更新选中状态
- (void)updateSelectStatus;

@end

NS_ASSUME_NONNULL_END
