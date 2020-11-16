//
//  NineLeftSide.m
//  RelievedInputMethod
//
//  Created by 靳翠翠 on 2020/7/20.
//  Copyright © 2020 靳翠翠. All rights reserved.
//

#import "NineLeftSide.h"
#import "LeftTableViewCell.h"

@interface  NineLeftSide ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NineChineseModel *nineModel; //数据源
@property (nonatomic, strong)NineNumberModel *numberModel; //cell展示model
@property (nonatomic, strong)RIEngineManager *engine; //引擎
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, assign)BOOL isSpell; //展示的是字母/符号，YES:字母 NO:符号

@end

@implementation NineLeftSide

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化引擎
        self.engine =[RIEngineManager manger];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    //阴影设置
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    CALayer *subLayer = [CALayer layer];
    CGRect fixframe = self.frame;
    subLayer.frame = fixframe;
    subLayer.cornerRadius = 5;
    subLayer.backgroundColor = [UIColor clearColor].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = [UIColor redColor].CGColor;      // shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(3,2);                // shadowOffset阴影偏移,x向右偏移3,y向下偏移2,默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.9;                           // 阴影透明度,默认0
    subLayer.shadowRadius = 0;                              // 阴影半径,默认3
    [self.layer insertSublayer:subLayer atIndex:0];
    
    //默认是符号
    self.isSpell =NO;
    if ([GetKeyboardStatus status].currentKeyboardType == Keyboard_NumNine) {
        //数字符号
        self.dataArray =self.numberModel.punctuations;
    }else{
        //标点符号
        self.dataArray =self.nineModel.punctuations;
    }
    [self addSubview:self.tableView];
}

//tableView约束只能在此方法中添加，其他位置无效
- (void)layoutWithWidth:(float)width height:(float)height{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _tableView.backgroundColor =Main_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator =NO;
    }
    return _tableView ;
}

- (NineChineseModel *)nineModel{
    if (!_nineModel) {
        _nineModel = [CharacterManger getNineChineseKeyboardSymbool];
    }
    return _nineModel;
}

- (NineNumberModel *)numberModel{
    if (!_numberModel) {
        _numberModel = [CharacterManger getNineNumberKeyboardSymbool];
    }
    return _numberModel;
}

- (void)setSpellArray:(NSArray *)spellArray {
    if (_spellArray != spellArray) {
        _spellArray =spellArray;
        self.dataArray =spellArray;
        self.isSpell = YES;
        //字母为空则展示符号
        if ([self.dataArray count] == 0) {
            self.isSpell = NO;
            self.dataArray =self.nineModel.punctuations;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height/ 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify =@"lifeSideCell";
    LeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[LeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSString *chars = self.dataArray[indexPath.row];
    cell.characterLabel.text =chars;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *chars = self.dataArray[indexPath.row];
    //数字键盘直接上屏
    if ([GetKeyboardStatus status].currentKeyboardType == Keyboard_NumNine) {
        [RIFuntionBtClickManger showOnScreen:chars];
        return;
    }
    
    //拼音九键
    if (self.isSpell) {
        //字母,调用引擎
        [self.engine clickSpellLetter:chars];
    }else{
        //符号直接上屏
        [RIFuntionBtClickManger showOnScreen:chars];
    }
}

@end
