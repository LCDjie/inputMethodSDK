//
//  MenuItemView.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/14.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "MenuItemView.h"

@implementation MenuItemView

- (instancetype)init{
    self =[super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self =[super init];
    if (self) {
        self.titleLabel.font = FontBold(13);
        [self setTitleColor:ToolsBar_Text_Color forState:UIControlStateNormal];
        [self setTitleColor:ToolsBar_Text_Selected_Color forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithImage:(NSString *)image selectImage:(NSString *)selectImage{
    self =[super init];
    if (self) {
        if (image) {
            [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        }
        
        if (selectImage) {
            [self setImage:[UIImage imageNamed:selectImage]                       forState:UIControlStateSelected];
        }
    }
    return self;
}

- (void)setUI {
    UILabel * label =[[UILabel alloc]init];
    label.textColor =[UIColor blackColor];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)updateSelectStatus {
    self.selected =!self.selected;
}

@end
