#import "RBAnalyFourthCell.h"
#import "RBAnalyzeTitleView.h"
#import "RBDetailInjuredCell.h"
#import "RBInjuredModel.h"
#import "RBInjuredHeadView.h"


@interface RBAnalyFourthCell ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *homedataArr;
@property (nonatomic, strong) NSMutableArray *awaydataArr;
@property(nonatomic,strong) UIView *footView;
@end

@implementation RBAnalyFourthCell
- (NSMutableArray *)homedataArr {
    if (_homedataArr == nil) {
        _homedataArr = [NSMutableArray array];
    }
    return _homedataArr;
}

- (NSMutableArray *)awaydataArr {
    if (_awaydataArr == nil) {
        _awaydataArr = [NSMutableArray array];
    }
    return _awaydataArr;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSDictionary *injuryDict =  dict[@"injury"];
    NSArray *home = injuryDict[@"home"];
    NSArray *away = injuryDict[@"away"];
    int count1 =  (int)(home.count);
    int count2 =  (int)(away.count);

    [self.tableView reloadData];
    [self.homedataArr removeAllObjects];
    for (int i = 0; i < count1; i++) {
        NSDictionary *dict = home[i];
        RBInjuredModel *cellModel = [RBInjuredModel mj_objectWithKeyValues:dict];
        [self.homedataArr addObject:cellModel];
    }
    [self.awaydataArr removeAllObjects];
    for (int i = 0; i < count2; i++) {
        NSDictionary *dict = away[i];
        RBInjuredModel *cellModel = [RBInjuredModel mj_objectWithKeyValues:dict];
        [self.awaydataArr addObject:cellModel];
    }
    int count = 2;
    if (self.homedataArr.count == 0) {
        count--;
    }
    if (self.awaydataArr.count == 0) {
        count--;
    }
    self.tableView.frame = CGRectMake(0, 46, RBScreenWidth, (self.homedataArr.count + self.awaydataArr.count) * 44 + 71 * count);
    [self.tableView reloadData];
    if (count1 == 0 && count2 == 0) {
        self.footView.hidden = NO;
    }
}



+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBAnalyFourthCell";
    RBAnalyFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        RBAnalyzeTitleView *titleView = [[RBAnalyzeTitleView alloc]initWithTitle:@"伤停情况" andFrame:CGRectMake(0, 0, RBScreenWidth, 46) andSecondTitle:@"" andDetail:@"" andFirstBtn:@"" andSecondBtn:@"" andClickFirstBtn:^(BOOL selected) {
        } andClickSecondBtn:^(BOOL selected) {
        }];
        [self addSubview:titleView];
        UIView *footView = [[UIView alloc]init];
        footView.hidden = YES;
        self.footView = footView;
        footView.backgroundColor = [UIColor whiteColor];
        footView.frame = CGRectMake(0, 0, RBScreenWidth, 0);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, RBScreenWidth, 53)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.text = @"赞无数据或无伤病";
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [footView addSubview:label];
        [self addSubview:footView];
        
        UITableView *tableView = [[UITableView alloc]init];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        self.tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailInjuredCell *cell = [RBDetailInjuredCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && self.homedataArr.count > 0) {
        RBInjuredModel *injuredModel = self.homedataArr[indexPath.row];
        injuredModel.isLast = (indexPath.row == self.homedataArr.count - 1);
        cell.injuredModel = injuredModel;
    } else {
        RBInjuredModel *injuredModel = self.awaydataArr[indexPath.row];
        injuredModel.isLast = (indexPath.row == self.awaydataArr.count - 1);
        cell.injuredModel = injuredModel;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 2;
    if (self.homedataArr.count == 0) {
        count--;
    }
    if (self.awaydataArr.count == 0) {
        count--;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.homedataArr.count > 0) {
        return self.homedataArr.count;
    } else {
        return self.awaydataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 71;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [RBInjuredHeadView HeadViewWithLogo:self.currentHostLogo andName:self.currentHostName];
    } else {
        return [RBInjuredHeadView HeadViewWithLogo:self.currentVisitingLogo andName:self.currentVisitingName];
    }
}

@end
