//
//  MenuToolsBar.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/14.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "MenuToolsBar.h"
#define  itemWidth  NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X
#define  itemHeight 38
@interface MenuToolsBar ()

@property(nonatomic, strong)UIScrollView *scrollView ;

@end

@implementation MenuToolsBar

- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UIView *horizontalLine =[[UIView alloc]init];
    horizontalLine.backgroundColor = Line_Color;
    [self addSubview:horizontalLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(25);
    }];
    
    UIView *verticalLine =[[UIView alloc]init];
    verticalLine.backgroundColor =Line_Color;
    [self addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_right);
        make.centerY.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(itemHeight/2);
    }];
    
    UIButton * dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropButton setImage:[UIImage imageNamed:@"bar_drop"] forState:UIControlStateNormal];
    [dropButton addTarget:self action:@selector(dropButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dropButton];
    [dropButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(verticalLine.mas_right);
        make.right.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self.scrollView);
    }];
}

- (void)configWithItems:(NSArray *)items {
    self.scrollView.contentSize = CGSizeMake(items.count * itemWidth, itemHeight);
    for (int i =0; i<items.count; i++ ) {
        MenuItemView *itemView = items[i];
        [self.scrollView addSubview:itemView];
        itemView.frame = CGRectMake(i *itemWidth, 0, itemWidth, itemHeight);
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH-itemWidth, itemHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)dropButtonAction:(UIButton *)bt {
    //发送收起键盘的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_DISMISS object:nil];
}
@end
