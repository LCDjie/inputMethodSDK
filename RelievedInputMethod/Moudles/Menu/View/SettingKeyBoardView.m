//
//  settingKeyBoardView.m
//  RelievedInputMethod
//
//  Created by liweijie on 2020/10/26.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "SettingKeyBoardView.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "KeyBoardItemCollectionViewCell.h"
#import "GetKeyboardStatus.h"

@interface SettingKeyBoardView() <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    UICollectionView *mainCollectionView;
}

@property(copy, nonatomic)NSMutableArray *titleArray;
@property(copy, nonatomic)NSMutableArray *imageArray;

@end


@implementation SettingKeyBoardView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
//    UIButton *settingNumber = [[UIButton alloc]init];
//
//    settingNumber.frame = CGRectMake(10, 10, ((SCREEN_WIDTH-10)/4), ((SCREEN_WIDTH-10)/4));
//
//    [settingNumber setTitle:@"键盘" forState:UIControlStateNormal];
//    [self addSubview:settingNumber];
    
    
    self.titleArray = [[NSMutableArray alloc]initWithObjects:@"键盘数字行", nil];
      self.imageArray = [[NSMutableArray alloc]initWithObjects:@"number_key_n",nil];
      // Do any additional setup after loading the view.
    double height = KeyBoardHeight;
    if ([GetKeyboardStatus status].numericKeypadLine) {
        height = KeyBoardHeight + kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace;
    } else {
        height = KeyBoardHeight;
    }
    
      UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,height)];
    
    
    
      addView.backgroundColor = kSwitchBoardColor;
      [self addSubview:addView];
      
      //初始化layout
    JYEqualCellSpaceFlowLayout * flowLayout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:0];

      mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 15,SCREEN_WIDTH,KeyBoardHeight-15) collectionViewLayout:flowLayout];
      [addView addSubview:mainCollectionView];
      mainCollectionView.backgroundColor = kSwitchBoardColor;
      //注册collectionViewCell。ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
      [mainCollectionView registerClass:[KeyBoardItemCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
      //设置代理
      mainCollectionView.delegate = self;
      mainCollectionView.dataSource = self;
}

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}
//绘制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    KeyBoardItemCollectionViewCell *cell = (KeyBoardItemCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
//    [cell.topImage setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    if (indexPath.row == 0) {
        if ([GetKeyboardStatus status].numericKeypadLine) {
            cell.topImage.image = [UIImage imageNamed:@"number_key_s"];
        } else {
            cell.topImage.image = [UIImage imageNamed:@"number_key_n"];
        }
    }
  
    cell.btmLabel.text = self.titleArray[indexPath.row];

    return cell;;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-10) / 4, (SCREEN_WIDTH-10) / 4);
}
//点击item方法

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KeyBoardItemCollectionViewCell *cell = (KeyBoardItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
       NSString *msg = cell.btmLabel.text;
    NSLog(@"选择键盘点击了%@",msg);
    
    if ([GetKeyboardStatus status].numericKeypadLine) {
        cell.topImage.image = [UIImage imageNamed:@"number_key_n"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_CHANGEHEIGHTKEYBOARD object:@"0"];

    } else {
        cell.topImage.image = [UIImage imageNamed:@"number_key_s"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_CHANGEHEIGHTKEYBOARD object:@"1"];

    }
    [GetKeyboardStatus status].numericKeypadLine = ![GetKeyboardStatus status].numericKeypadLine;

    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",Keyboard_PinyinFull]];
           
//    [[RIEngineManager manger] zhKeyboardTypeExchange];
    
    
    
}

@end
