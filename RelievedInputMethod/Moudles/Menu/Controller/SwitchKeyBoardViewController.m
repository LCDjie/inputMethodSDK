//
//  SwiftKeyBoardViewController.m
//  RelievedInputMethod
//
//  Created by liweijie on 2020/9/4.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "SwitchKeyBoardViewController.h"
#import "KeyBoardItemCollectionViewCell.h"
#import "GetKeyboardStatus.h"
#import "JYEqualCellSpaceFlowLayout.h"
@interface SwitchKeyBoardViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    UICollectionView *mainCollectionView;
}

@property(copy, nonatomic)NSMutableArray *titleArray;
@property(copy, nonatomic)NSMutableArray *imageArray;

@end

@implementation SwitchKeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = [[NSMutableArray alloc]initWithObjects:@"拼音九键",@"拼音全键",@"英文全键", nil];
    self.imageArray = [[NSMutableArray alloc]initWithObjects:@"selece_nineKey_normal",@"selece_allCn_normal",@"selece_allEn_normal",nil];
    // Do any additional setup after loading the view.
    double height = KeyBoardHeight;
    if ([GetKeyboardStatus status].numericKeypadLine) {
        height = KeyBoardHeight + kAXASCIIKeyboardBtnHeight + kAXASCIIKeyboardBtnVerticalSpace;
    } else {
        height = KeyBoardHeight;
    }
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,height)];
    addView.backgroundColor = kSwitchBoardColor;
    [self.view addSubview:addView];
    
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
    
    [cell.topImage setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    cell.btmLabel.text = self.titleArray[indexPath.row];
    //判断当前键盘
    if ((indexPath.row == 0) && ([GetKeyboardStatus status].currentKeyboardType == Keyboard_PinyinNine)) {
        [cell.topImage setImage:[UIImage imageNamed:@"selece_nineKey_selected"]];
       
    }
    if ((indexPath.row == 1) && ([GetKeyboardStatus status].currentKeyboardType == Keyboard_PinyinFull)) {
        [cell.topImage setImage:[UIImage imageNamed:@"selece_allCn_selected"]];
       
    }
    if ((indexPath.row == 2) && ([GetKeyboardStatus status].currentKeyboardType == Keyboard_ENFull)) {
        [cell.topImage setImage:[UIImage imageNamed:@"selece_allEn_selected"]];
        //添加数字键盘后的高度。

    }
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
    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",Keyboard_PinyinNine]];
    } else if (indexPath.row == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",Keyboard_PinyinFull]];
    } else if (indexPath.row == 2) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",Keyboard_ENFull]];
    }
    
}

@end


