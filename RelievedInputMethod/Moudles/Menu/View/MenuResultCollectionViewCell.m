//
//  MenuResultCollectionViewCell.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/24.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "MenuResultCollectionViewCell.h"

@interface MenuResultCollectionViewCell ()

@end

@implementation MenuResultCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)resultLabel{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.textColor = ToolsBar_Text_Color;
        CGFloat candiFontSize = ([RIAppGroupManager getKeyboardSetting] ? ([[[RIAppGroupManager getKeyboardSetting] objectForKey:@"candidateFontSize"] floatValue] * 20 / 0.6) : 20.0);
        _resultLabel.font =[UIFont systemFontOfSize:candiFontSize];
        [self.contentView addSubview:_resultLabel];
    }
    return _resultLabel;
}

- (void)configUI:( NSIndexPath*)index{
    _resultLabel.textColor = ToolsBar_Text_Color;
    if (index.row ==0) {
        _resultLabel.textColor = ToolsBar_Text_Selected_Color;
    }
}

@end
