//
//  MenuCandidateBar.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/24.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#define  itemWidth  NineKB_Side_Bt_Width(SCREEN_WIDTH) + NineKB_Space_Bound_X
#define  itemHeight 38
#import "MenuCandidateBar.h"
#import "MenuResultCollectionViewCell.h"
static dispatch_once_t onceToken;
static MenuCandidateBar *bar =nil;

@interface MenuCandidateBar ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) RIEngineManager *engineManger; //引擎
@property (nonatomic, strong) UILabel *spellLabel; //待确定拼音label
@property (nonatomic, strong) UIScrollView *spellScrollView; //带待确定拼音ScrollView
@property (nonatomic, strong) UIButton * dropButton; //收起键盘button
@property (nonatomic, strong) UIView * verticalLine; //右竖分割线

@end

@implementation MenuCandidateBar

+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        bar = [[MenuCandidateBar alloc]init];
    });
    return bar;
}

- (instancetype)init{
    self =[super init];
    if (self) {
        //初始化引擎
        self.engineManger =[RIEngineManager manger];
        [self setUI];
    }
    return self;
}

//销毁
+ (void)destroy
{
    onceToken = 0;
    bar = nil;
}

- (void)setUI {
    self.spellScrollView = [[UIScrollView alloc]init];
    

    self.spellScrollView.showsVerticalScrollIndicator = NO;
    self.spellScrollView.showsHorizontalScrollIndicator = NO;
    self.spellScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    [self addSubview:self.spellScrollView];
    [self.spellScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH / 2 + 10);
        make.height.mas_equalTo(25);
    }];
    
    self.spellLabel = [[UILabel alloc]init];
    self.spellLabel.font = FontRegular(13.f);
    self.spellLabel.textColor = kBtnTopTitleColor;
    [self.spellScrollView addSubview:self.spellLabel];
    [self.spellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.spellScrollView);
        make.height.mas_equalTo(self.spellScrollView);
        make.width.mas_equalTo(self.spellScrollView.contentSize.width);
    }];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, SCREEN_WIDTH,0.5);
    topBorder.backgroundColor = Line_Color.CGColor;
    [self.layer addSublayer:topBorder];
    
    
    UIView *horizontalLine =[[UIView alloc]init];
    horizontalLine.backgroundColor = Line_Color;
    [self addSubview:horizontalLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(25);
    }];
    
    
    self.verticalLine =[[UIView alloc]init];
    self.verticalLine.backgroundColor =Line_Color;
    [self addSubview:self.verticalLine];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionView.mas_right);
        make.centerY.mas_equalTo(self.collectionView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(itemHeight/2);
    }];
    
}

- (UIButton *)dropButton {
    if (!_dropButton) {
        self.dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsEmptyString(self.spellStr) && self.dataArray.count >0) {
            [self.dropButton setImage:[UIImage imageNamed:@"bar_hidden"] forState:UIControlStateNormal];
        }else{
            [self.dropButton setImage:[UIImage imageNamed:@"bar_arrow_down"] forState:UIControlStateNormal];
        }
        [self.dropButton setImage:[UIImage imageNamed:@"bar_arrow_up"] forState:UIControlStateSelected];
        [self.dropButton addTarget:self action:@selector(dropButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.dropButton];
        [self.dropButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(self.verticalLine.mas_right);
             make.right.mas_equalTo(self);
             make.top.bottom.mas_equalTo(self.collectionView);
         }];
    }
    return _dropButton;
}

- (void)dropButtonAction:(UIButton *)bt {
    if (kIsEmptyString(self.spellStr)) {
        //没有待确定拼音，隐藏候选词bar，重置引擎
        [self.engineManger reset];
        self.hidden =YES;
    }else{
        bt.selected =!bt.selected;
        if (bt.selected) {
            //展示候选词页
            [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)Keyboard_Candidate]];
        }else {
            //收起候选词页
            [[NSNotificationCenter defaultCenter]postNotificationName:KEYBOARD_SWITCH object:[NSString stringWithFormat:@"%lu",(unsigned long)[GetKeyboardStatus status].lastKeyboardType]];
        }
    }
}

- (void)reloadCollectionData{
    
    CGRect tmpRect =  [self.spellStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 25)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:FontRegular(13.f)}
                                                  context:nil];
    CGFloat  width = tmpRect.size.width;
    self.spellScrollView.contentSize = CGSizeMake(width, 0);
    [self.spellScrollView setContentOffset:CGPointMake(width - (SCREEN_WIDTH / 2 + 10) > 0 ? width - (SCREEN_WIDTH / 2 + 10) : 0, 0)];
    self.spellLabel.text =self.spellStr;
    [self.collectionView reloadData];
    
    [self.dropButton removeFromSuperview];
    self.dropButton =nil;
    self.dropButton.backgroundColor =[UIColor clearColor];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH-itemWidth, itemHeight) collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MenuResultCollectionViewCell class] forCellWithReuseIdentifier:@"MenuResultCollectionViewCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count =[self.dataArray count];
    if (count >30) {
        count =30;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MenuResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuResultCollectionViewCell" forIndexPath:indexPath];
    [cell configUI:indexPath];
    NSString * title = [self.dataArray objectAtIndex:indexPath.row];
    cell.resultLabel.text = title;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * title = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat candiFontSize = ([RIAppGroupManager getKeyboardSetting] ? ([[[RIAppGroupManager getKeyboardSetting] objectForKey:@"candidateFontSize"] floatValue] * 20 / 0.6) : 20.0);
    CGRect tmpRect =  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:MIN(25, MAX(candiFontSize, 15))]}
                                         context:nil];
    return CGSizeMake(tmpRect.size.width + 15, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //调用引擎
    [self.engineManger clickCandidateAt:(int)indexPath.row];
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
