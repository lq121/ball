#import "RBSelectedVC.h"
#import "RBBiSaiModel.h"
#import "RBSelectCell.h"
#import "RBSelectModel.h"

@interface RBSelectedVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *preResultArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *pinyinDic;
@end

@implementation RBSelectedVC
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赛事选择";
    [self setupHeadView];
    [self setupTableView];
    [self setupBottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pinyinDic = [NSMutableDictionary dictionaryWithDictionary:@{ @"A": @(1), @"B": @(2), @"C": @(3), @"D": @(4), @"E": @(5), @"F": @(6), @"G": @(7), @"H": @(8), @"I": @(9), @"J": @(10), @"K": @(11), @"L": @(12), @"M": @(13), @"N": @(14), @"O": @(15), @"P": @(16), @"Q": @(17), @"R": @(18), @"S": @(19), @"T": @(20), @"U": @(21), @"V": @(22), @"W": @(23), @"X": @(24), @"Y": @(25), @"Z": @(26) }];
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"matchArr"];
    NSSet *set = [NSSet setWithArray:array];
    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObjectsFromArray:[set allObjects]];
    NSMutableArray *PreArr = [NSMutableArray array];
    for (NSString *str in dataArr) {
        [PreArr addObject:[NSString shouZiMu:str]];
    }
    NSSet *set2 = [NSSet setWithArray:PreArr];
    self.preResultArr = [NSMutableArray arrayWithArray:[set2 allObjects]];

    [self.preResultArr sortUsingComparator:^NSComparisonResult (NSString *str1, NSString *str2) {
        str1 = [self getLatinWithFullName:str1];
        str2 = [self getLatinWithFullName:str2];
        NSComparisonResult result = [str1 compare:str2];
        return result;
    }];

    for (int i = 0; i < self.preResultArr.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        int k = 0;
        NSString *p = self.preResultArr[i];
        for (int j = 0; j < dataArr.count; j++) {
            RBSelectModel *selectModel = [[RBSelectModel alloc]init];
            NSString *f = [NSString shouZiMu:dataArr[j]];
            if ([p isEqualToString:f]) {
                selectModel.preTitle = p;
                selectModel.title = dataArr[j];
                selectModel.selected = NO;
                selectModel.section = i;
                selectModel.row = k;
                k++;
                [arr addObject:selectModel];
            }
        }
        [self.dataArr addObject:arr];
    }

    NSArray *seletmatchArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"seletmatchArr"];
    if (seletmatchArr != nil || seletmatchArr.count > 0) {
        for (int i = 0; i < seletmatchArr.count; i++) {
            for (int j = 0; j< self.dataArr.count;j++) {
                NSArray *arr = self.dataArr[j];
                for (int k = 0; k< arr.count;k++) {
                    RBSelectModel *model = arr[k];
                    if ([model.title isEqualToString:seletmatchArr[i]]) {
                        model.selected = YES;
                    }
                }
                self.dataArr[j] = arr;
            }
        }
    } else {
        for (int i = 0; i< self.dataArr.count;i++) {
            NSArray *arr = self.dataArr[i];
            for (RBSelectModel *model in arr) {
                model.selected = YES;
            }
            self.dataArr[i] = arr;
        }
    }

    [self.tableView reloadData];
}

- (void)setupHeadView {
    NSArray *titles = @[@"完整", @"一级", @"竞彩", @"北单", @"足彩"];
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
    selectView.backgroundColor = [UIColor whiteColor];
    self.selectView = selectView;
    [self.view addSubview:selectView];
    CGFloat width = (RBScreenWidth - 40) / titles.count;
    CGFloat heigth = 44;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20 + i * width, 0, width, heigth)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [selectView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn.tag = 200 + i;
        if (i == 0) {
            btn.selected = YES;
            self.checkBtn = btn;
            [self clickCheckBtn:btn];
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.indicateView = [[UIView alloc]init];
    self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    self.indicateView.frame = CGRectMake(0, 40, 28, 4);
    self.indicateView.x = self.checkBtn.x + (self.checkBtn.frame.size.width - 20) * 0.5;
    [selectView addSubview:self.indicateView];
    [self.view addSubview:selectView];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - 44 - RBBottomSafeH - 72)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.sectionIndexColor = [UIColor colorWithSexadeString:@"#2B8AF7"];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight - 72 - RBBottomSafeH - RBNavBarAndStatusBarH, RBScreenWidth, 72)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    CGFloat width = (RBScreenWidth - 190 - 16) * 0.5;

    UIButton *selectAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 12, width, 48)];
    [selectAllBtn addTarget:self action:@selector(clickAllBtn) forControlEvents:UIControlEventTouchUpInside];
    [selectAllBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];

    UIButton *noSelectAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame), 12, width, 48)];
    [noSelectAllBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    [noSelectAllBtn addTarget:self action:@selector(clicknoAllBtn) forControlEvents:UIControlEventTouchUpInside];
    [noSelectAllBtn setTitle:@"反选" forState:UIControlStateNormal];

    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(RBScreenWidth - 190, 12, 184, 48);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"btn mid sure"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:selectAllBtn];
    [bottomView addSubview:noSelectAllBtn];
    [bottomView addSubview:sureBtn];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame), (72 - 29) * 0.5, 2, 29)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [bottomView addSubview:line];
}

- (void)clickCheckBtn:(UIButton *)btn {
    self.checkBtn.selected = NO;
    btn.selected = YES;
    self.checkBtn = btn;
    [UIView animateWithDuration:durationTime animations:^{
        self.indicateView.centerX = self.checkBtn.centerX;
    }];
}

// 全选
- (void)clickAllBtn {
    for (int i = 0; i < self.dataArr.count; i++) {
        NSMutableArray *arr = self.dataArr[i];
        for (int j = 0; j < arr.count; j++) {
            RBSelectModel *model = arr[j];
            model.selected = YES;
            arr[j] = model;
        }
        self.dataArr[i] = arr;
    }
    [self.tableView reloadData];
}

// 反选
- (void)clicknoAllBtn {
    for (int i = 0; i < self.dataArr.count; i++) {
        NSMutableArray *arr = self.dataArr[i];
        for (int j = 0; j < arr.count; j++) {
            RBSelectModel *model = arr[j];
            model.selected = !model.selected;
            arr[j] = model;
        }
        self.dataArr[i] = arr;
    }
    [self.tableView reloadData];
}

// 确定
- (void)clickSureBtn {
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArr.count; i++) {
        NSMutableArray *arr = self.dataArr[i];
        for (int j = 0; j < arr.count; j++) {
            RBSelectModel *model = arr[j];
            if (model.selected) {
                [resultArr addObject:model.title];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:resultArr forKey:@"seletmatchArr"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

//优化速度
- (NSString *)getLatinWithFullName:(NSString *)name {
    //1.先从缓存中获得latin，然后再判断是否存在，再将非字符串转化成拉丁字母
    NSString *latin = [self.pinyinDic objectForKey:name];
    if (latin) {
        return latin;
    } else {
        latin = [NSString stringWithString:name];
        CFStringTransform((__bridge CFMutableStringRef)latin, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)latin, NULL, kCFStringTransformStripDiacritics, NO);
        [self.pinyinDic setObject:latin forKey:name];
        return latin;
    }
}

#pragma mark - Table view data source

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.preResultArr;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.preResultArr[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.preResultArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBSelectCell *cell = [RBSelectCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataArr = self.dataArr[indexPath.section];
    __weak typeof(self) weakSelf = self;
    cell.clickBtn = ^(RBSelectModel *model) {
        int section = model.section;
        int row = model.row;
        NSMutableArray *arr = self.dataArr[section];
        arr[row] = model;
        weakSelf.dataArr[section] = arr;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.dataArr[indexPath.section];
    int count = 0;
    if (arr.count % 3 != 0) {
        count += 1;
    }
    count += arr.count / 3;
    return 40 * count;
}

@end
