#import "RBXinWenBiSaiViewCell.h"
#import "RBXinWenBiSaiCell.h"
#import "RBBiSaiModel.h"
#import "RBTabBarVC.h"
#import "RBBiSaiDetailVC.h"

@interface RBXinWenBiSaiViewCell ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBXinWenBiSaiViewCell
- (void)setBiSaiArr:(NSArray *)biSaiArr {
    _biSaiArr = biSaiArr;
    self.tableView.frame = CGRectMake(0, 31, RBScreenWidth, 61 * 3);
    [self.tableView reloadData];
    self.btn.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), RBScreenWidth, 44);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.btn.frame), RBScreenWidth, 12);
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBXinWenBiSaiViewCell";
    RBXinWenBiSaiViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:@"time of game"];
        icon.frame = CGRectMake(0, 0, 133, 31);
        [titleView addSubview:icon];

        UILabel *label = [[UILabel alloc]init];
        self.label = label;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = [NSString getComperStrWithDateInt:[[NSDate date] timeIntervalSince1970] andFormat:@"yyyy/MM/dd"];
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(12, 8, 110, 17);
        [icon addSubview:label];
        [self addSubview:titleView];

        UITableView *tableView = [[UITableView alloc]init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        self.tableView = tableView;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self addSubview:tableView];

        UIButton *btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
        self.btn = btn;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:@"查看更多" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:btn];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [self addSubview:line];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.biSaiArr.count >= 3) {
        return 3;
    } else {
        return self.biSaiArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBXinWenBiSaiCell *cell = [RBXinWenBiSaiCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.biSaiModel = self.biSaiArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBBiSaiModel *biSaiModel = self.biSaiArr[indexPath.row];
    RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
    detailTabVC.biSaiModel = biSaiModel;
    if (biSaiModel.status == 1 || biSaiModel.status > 8) {
        // 未
        detailTabVC.index = 3;
    } else {
        // 比赛进行时
        detailTabVC.index = 0;
    }
    [[UIViewController getCurrentVC].navigationController pushViewController:detailTabVC animated:YES];
}

- (void)clickMoreBtn {
    RBTabBarVC *tabBarVC = (RBTabBarVC *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    tabBarVC.selectedIndex = 3;
}

@end
