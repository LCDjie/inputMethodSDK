//
//  LeftTableViewCell.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/20.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        
    }
    return self;
}

- (void)setUI {
    self.backgroundColor =Main_Color;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    [self.characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)characterLabel {
    if (!_characterLabel) {
        _characterLabel = [[UILabel alloc] init];
        _characterLabel.adjustsFontSizeToFitWidth = YES;
        _characterLabel.font = [UIFont systemFontOfSize:16.f];
        _characterLabel.textColor = Btn_Main_Title_Color;
        _characterLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.characterLabel];
    }
    return _characterLabel;
}

@end
