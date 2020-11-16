//
//  KeyBoardItemCollectionViewCell.m
//  RelievedInputMethod
//
//  Created by liweijie on 2020/9/7.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "KeyBoardItemCollectionViewCell.h"

@implementation KeyBoardItemCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topImage = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 50 *ScreespecOne)/2, 0, 50*ScreespecOne, 50*ScreespecOne)];
        [self.contentView addSubview:self.topImage];
        self.btmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*ScreespecOne + 2, frame.size.width, 20)];
        self.btmLabel.textAlignment = NSTextAlignmentCenter;
        self.btmLabel.textColor = kSwitchBoardTextColor;
        self.btmLabel.font = [UIFont systemFontOfSize:13.5];
        
        [self.contentView addSubview:self.btmLabel];
    }
    return self;
}


@end





















