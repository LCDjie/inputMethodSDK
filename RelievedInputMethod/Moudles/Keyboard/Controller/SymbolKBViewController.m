//
//  SymbolKBViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/9.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "SymbolKBViewController.h"
#import <MJRefresh.h>
#import "RICandidateWordCollectionViewCell.h"

@interface SymbolKBViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UITableView *tableView; //左侧标题栏
@property (nonatomic, strong)NSArray *itemArray; //标题数组
@property (nonatomic, strong)NSIndexPath *index; //已选中index
@property (nonatomic, strong)UICollectionView *collectionView; //符号键盘
@property (nonatomic, strong)NSMutableArray *dataArray; //符号model数组
@property (nonatomic, strong)NSMutableArray *originalArray; //初始符号数组
@property (nonatomic, strong)UIView *bottomView; //底栏

@end

@implementation SymbolKBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//约束布局必须在此方法内，否则布局无效
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X);
        make.bottom.equalTo(self.view.mas_bottom).offset(-self.view.frame.size.height/5);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X);
        make.bottom.mas_equalTo(self.tableView.mas_bottom);
        make.right.top.equalTo(self.view);
    }];
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];
    
    //符号键盘刷新
    SpecificSymbolTypeModel *model = self.itemArray[0];
    self.originalArray =[NSMutableArray arrayWithArray:model.symboolArrays];
    [self reloadData];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor =Main_Color;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[RICandidateWordCollectionViewCell class] forCellWithReuseIdentifier:@"RICandidateWordCollectionViewCell"];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.right.top.equalTo(self.view);
        }];
    }
    return _collectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.dataSource =self;
        _tableView.delegate =self;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor ly_colorWithHexString:@"#F1F2F4"];
        [self.view addSubview:_bottomView];
        
        CGFloat fristwidth =NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X;
        CGFloat itemWidth =(SCREEN_WIDTH - fristwidth)/4;
        UIButton *backButton =[[UIButton alloc]init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:kBtnTopTitleColor forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.titleLabel.font =[UIFont systemFontOfSize:16.f];
        [_bottomView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(itemWidth);
            make.top.bottom.equalTo(_bottomView);
        }];
        
        UIButton * lockButton =[[UIButton alloc]init];
        [self.view addSubview:lockButton];
        [lockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backButton.mas_right);
            make.width.mas_equalTo(itemWidth);
            make.top.bottom.mas_equalTo(_bottomView);
        }];
        
    }
    return _bottomView;
}

- (NSArray *)itemArray {
    if (!_itemArray) {
        _itemArray =[CharacterManger getSpecificSymbool];
    }
    return _itemArray;
}

- (void)reloadData{
    //符号数组数据处理，键盘刷新
    if (self.originalArray.count <= 0) {
        return;
    }
    CGFloat maxWidth = SCREEN_WIDTH - (NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X); //符号模块宽度
    maxWidth = floor(maxWidth);
    CGFloat totlewidth = 0.0; //记录每行总长度
    self.dataArray =[[NSMutableArray alloc]init];
    for (int i=0 ; i< self.originalArray.count ; i++) {
        NSString * word = self.originalArray[i];
        MenuCandidateModel *model =[[MenuCandidateModel alloc]init];
        model.title = word;
        totlewidth  = totlewidth + model.width;
        //总宽度大于行最多宽度时，将最后一个词去掉放在下一行，上一个词扩充宽度
        if (totlewidth - maxWidth >0 && self.dataArray.count >0) {
            MenuCandidateModel *lastModel = self.dataArray[i-1];
            [self.dataArray removeLastObject];
            lastModel.width = maxWidth - (totlewidth - lastModel.width - model.width);
            [self.dataArray addObject:lastModel];
            totlewidth = model.width;
        }
        [self.dataArray addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)backButtonAction:(UIButton *)bt {
    //返回上一个键盘
    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].lastKeyboardType]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify =@"SymbolCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.textLabel.textColor = kBtnTopTitleColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SpecificSymbolTypeModel *model = self.itemArray[indexPath.row];
    cell.textLabel.text =model.type;
    if (!self.index) {
        if (indexPath.row == 0) {
            //默认选中
            cell.backgroundColor = Main_Color;
        } else {
            cell.backgroundColor =[UIColor ly_colorWithHexString:@"#EDEFF1"];
        }
    }else {
        if (self.index.row == indexPath.row) {
            //选中颜色
            cell.backgroundColor = Main_Color;
        } else {
            cell.backgroundColor =[UIColor ly_colorWithHexString:@"#EDEFF1"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.index = indexPath;
    //刷新以显示选中颜色
    [self.tableView reloadData];
    
    //刷新符号模块
    SpecificSymbolTypeModel *model = self.itemArray[indexPath.row];
    self.originalArray =[NSMutableArray arrayWithArray:model.symboolArrays];
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/5;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RICandidateWordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RICandidateWordCollectionViewCell" forIndexPath:indexPath];
    MenuCandidateModel *model =self.dataArray[indexPath.row];
    [cell configUI:model];
    cell.leftline.hidden = NO;
    cell.bottomline.hidden = NO;
    cell.backgroundColor =Main_Color;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuCandidateModel *model =self.dataArray[indexPath.row];
    CGFloat height = self.view.frame.size.height/5;
    return CGSizeMake(model.width,height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //行间距
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //列间距
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    RICandidateWordCollectionViewCell *cell = (RICandidateWordCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //点击显示效果，此处没有效果，需要排查原因
    [cell setBackgroundColor:[UIColor grayColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    RICandidateWordCollectionViewCell *cell = (RICandidateWordCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:Main_Color];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //符号上屏
    MenuCandidateModel *model =self.dataArray[indexPath.row];
    [[GetKeyboardStatus status].textDocumentProxy insertText:model.title];
    NSLog(@"dd");
    [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].lastKeyboardType]];
}
@end
