//
//  NineRightSide.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/17.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "NineRightSide.h"
#import "NSArray+Sudoku.h"

@implementation NineRightSide

- (instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        [self setUIWithItems:items];
    }
    return self;
}

- (void)setUIWithItems:(NSArray *)items{
    self.backgroundColor = Keyboard_Background_Color;
    for (id view in items) {
        [self addSubview:view];
    }
}

//给按钮布局
- (void)layoutWithWidth:(float)width height:(float)height{
    [self.subviews  mas_distributeSudokuViewsWithFixedLineSpacing:NineKB_Space_Y fixedInteritemSpacing:NineKB_Space_X warpCount:1 topSpacing:NineKB_Space_Bound_Y bottomSpacing:NineKB_Space_Bound_Y leadSpacing:0 tailSpacing:NineKB_Space_Bound_X];
}


@end
