#import "RBDengjiDesTabVC.h"
#import "RBDengJiDesModel.h"
#import "RBDengJiDesCell.h"

@interface RBDengjiDesTabVC ()
@property (strong, nonatomic) NSMutableArray *models;
@end

@implementation RBDengjiDesTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"等级说明表";
    NSArray *experienceArr = @[@(0), @(10), @(55), @(145), @(290), @(500), @(785), @(1155), @(1620), @(2285), @(3248), @(4607), @(6460), @(8905), @(12040), @(15963), @(20772), @(26565), @(33440), @(42315), @(53689), @(68061), @(85930), @(107795), @(134155), @(165509), @(202356), @(245195), @(294525), @(353855), @(425182), @(510503), @(611815), @(731115), @(870400), @(1031667), @(1216913), @(1428135), @(1667330), @(1936525), @(2245716), @(2604899), @(3024070), @(3513225), @(4082360), @(4741471), @(5500554), @(6369605), @(7358620), @(8477635)];
    self.models = [NSMutableArray array];
    for (int i = 0; i < experienceArr.count; i++) {
        RBDengJiDesModel *model = [[RBDengJiDesModel alloc]init];
        model.ID = i + 1;
        model.grade = i + 1;
        model.textColor = @"#ffffff";
        if (i < 9) {
            model.bgColor = [UIColor colorWithSexadeString:@"#95C4FA"];
        } else if (i < 19) {
            model.bgColor = [UIColor colorWithSexadeString:@"#8B8FFF"];
        } else if (i < 29) {
            model.bgColor = [UIColor colorWithSexadeString:@"#98D1B2"];
        } else if (i <= 39) {
            model.bgColor = [UIColor colorWithSexadeString:@"#FFC57F"];
        } else {
            model.bgColor = [UIColor colorWithSexadeString:@"#FF9D95"];
        }

        model.experience = [experienceArr[i] intValue];
        [self.models addObject:model];
    }
    [self.tableView reloadData];
}

    #pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
    headView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"等级";
    [headView addSubview:label1];
    label1.frame = CGRectMake(16, 16, (RBScreenWidth - 32) / 3, 20);

    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"所需经验";
    [headView addSubview:label2];
    label2.frame = CGRectMake(CGRectGetMaxX(label1.frame), 16, (RBScreenWidth - 32) / 3, 20);

    UILabel *label3 = [[UILabel alloc]init];
    label3.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    label3.font = [UIFont systemFontOfSize:14];
    label3.frame = CGRectMake(CGRectGetMaxX(label2.frame), 16, (RBScreenWidth - 32) / 3, 20);
    label3.textAlignment = NSTextAlignmentRight;
    label3.text = @"等级图标";
    [headView addSubview:label3];

    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDengJiDesCell *cell = [RBDengJiDesCell createCellByTableView:tableView];
    cell.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    return cell;
}

@end
