//
//  RICandidateWordViewController.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/30.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "RICandidateWordViewController.h"
#import "MenuCandidateBar.h"
#import "MenuCandidateModel.h"
#import "RICandidateWordCollectionViewCell.h"
#import "LeftTableViewCell.h"
#import "RIEngineManager.h"
#import <MJRefresh.h>

@interface RICandidateWordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,RIEngineManagerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView; //候选词模块
@property (nonatomic, strong) UITableView *tableView; //字母侧栏
@property (nonatomic, strong) NSMutableArray *originalArray; //候选词数据源
@property (nonatomic, strong) NSMutableArray *dataArray; //候选词model数组
@property (nonatomic, assign) NSInteger pagenum; //collectionView的cell数量
@property (nonatomic, strong) NSArray *spellArray; //字母数组
@property (nonatomic, strong) RIEngineManager *engine; //引擎
@end

@implementation RICandidateWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化引擎
    self.engine =[RIEngineManager manger];
    self.view.backgroundColor =[UIColor whiteColor];
    
    //候选词源数据
    self.originalArray =[MenuCandidateBar shareInstance].dataArray ;
    //字母源数据
    self.spellArray = [MenuCandidateBar shareInstance].spellArray ;
    self.pagenum =0;
    //首次刷新collectionView
    [self reloadData:YES];
}

//约束布局必须在此方法内，否则布局无效
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.collectionView.mas_left);
        make.top.bottom.equalTo(self.view);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.top.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加引擎代理
    [self.engine addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除引擎代理
    [self.engine removeDelegate:self];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor =[UIColor ly_colorWithHexString:@"#EDEFF1"];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator =NO;
    }
    return _tableView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor =Keyboard_Background_Color;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[RICandidateWordCollectionViewCell class] forCellWithReuseIdentifier:@"RICandidateWordCollectionViewCell"];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.collectionView.mj_footer  beginRefreshing];
            [self reloadData:NO];
        }];
        footer.automaticallyRefresh = NO;
        footer.stateLabel.text = nil;
        [footer setTitle:@"更多候选词" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        _collectionView.mj_footer = footer;
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.right.top.equalTo(self.view);
        }];
    }
    return _collectionView;
}

- (void)reloadData:(BOOL)isFrist {
    NSInteger lastCount = self.pagenum ;
    if (isFrist) {
        //第一页
        self.dataArray =[[NSMutableArray alloc]init];
        if (self.originalArray.count > 30) {
            //每页最多展示30个
            self.pagenum = 30;
        }else{
            self.pagenum = self.originalArray.count;
        }
    }else if (self.originalArray.count >self.pagenum){
        //还有未展示的item
        NSInteger count = self.originalArray.count - self.pagenum;
        if (count >30) {
            self.pagenum = self.pagenum +30;
        }else{
            self.pagenum = self.pagenum +count;
        }
        
    }else{
        //item已全部展示
        return;
    }
    
    CGFloat maxWidth =SCREEN_WIDTH - (NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X + NineKB_Space_X);//符号模块宽度
    CGFloat totlewidth = 0.0;//记录每行总长度
    for (int i=0 ; i< self.pagenum -lastCount ; i++) {
        if (self.originalArray.count > lastCount +i) {
            NSString * word = self.originalArray[lastCount +i];
            MenuCandidateModel *model =[[MenuCandidateModel alloc]init];
            model.title = word;
            totlewidth  = totlewidth  + model.width;
            //总宽度大于行最多宽度时，将最后一个词去掉放在下一行，上一个词扩充宽度
            if (totlewidth - maxWidth >0 && self.dataArray.count >0) {
                MenuCandidateModel *lastModel = self.dataArray[lastCount + i-1];
                [self.dataArray removeLastObject];
                lastModel.width = floor(maxWidth - (totlewidth - lastModel.width - model.width));
                [self.dataArray addObject:lastModel];
                totlewidth = model.width;
            }
            [self.dataArray addObject:model];
        }
    }
    self.collectionView.mj_footer.hidden = self.originalArray.count == self.pagenum ? YES : NO;
    [self.collectionView.mj_footer  endRefreshing];
    [self.collectionView reloadData];
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
    cell.backgroundColor =Keyboard_Background_Color;
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
    [cell setBackgroundColor:Keyboard_Background_Color];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    RICandidateWordCollectionViewCell *cell = (RICandidateWordCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //点击效果（闪现变色）
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //调用引擎
    [self.engine clickCandidateAt:(int)indexPath.row];
}


#pragma -mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.spellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify =@"CandidateTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSString *chars = self.spellArray[indexPath.row];
    cell.textLabel.text =chars;
    cell.backgroundColor =[UIColor ly_colorWithHexString:@"#EDEFF1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击拼音，调用引擎
    NSString *chars = self.spellArray[indexPath.row];
    [self.engine clickSpellLetter:chars];
}

#pragma -mark RIEngineManagerDelegate

- (void)getFetchInputData:(NSArray<NSString *> *)candidateWords pinyin:(NSArray<NSString *> *)aPinyinWords confirmingPinyin:(NSString *)aConfirmingPinyin onScreenText:(NSString *)aOnScreenText preWordAndCurPinyin:(NSString *)preWordAndCurPinyin {
    //没有待确定的拼音时返回原键盘
    KeyboardType currentType =[GetKeyboardStatus status].currentKeyboardType;
    if (kIsEmptyString(aConfirmingPinyin) && currentType == Keyboard_Candidate) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].lastKeyboardType]];
        return ;
    }
    
    //刷新collectionview
    self.originalArray = candidateWords;
    self.pagenum = 0;
    [self reloadData:YES];
}

@end
