//
//  RICandidateWordCollectionViewCell.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/31.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "RICandidateWordCollectionViewCell.h"

@interface RICandidateWordCollectionViewCell ()

@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation RICandidateWordCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [self.leftline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(0.5);
        }];
        
        [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).equalTo(@-0.5);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (UILabel *)resultLabel{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.textColor = ToolsBar_Text_Color;
        _resultLabel.font =FontRegular17;
        [self.contentView addSubview:_resultLabel];
    }
    return _resultLabel;
}

- (UILabel *)leftline{
    if (!_leftline) {
        _leftline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _leftline.backgroundColor = Bt_Other_Background_Color;
        _leftline.hidden = YES;
        [self.contentView addSubview:self.leftline];
    }
    return _leftline;
}

- (UILabel *)bottomline{
    if (!_bottomline) {
        _bottomline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bottomline.backgroundColor = Bt_Other_Background_Color;
        _bottomline.hidden = YES;
        [self.contentView addSubview:self.bottomline];
    }
    return _bottomline;
}

- (void)configUI:(MenuCandidateModel *)model{
    _resultLabel.text = model.title;
}

@end
