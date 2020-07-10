#import "RBSizeTableVC.h"
#import "RBPlateCell.h"
#import "RBAiDataModel.h"

@interface RBSizeTableVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation RBSizeTableVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setSizeArr:(NSArray *)sizeArr {
    _sizeArr = sizeArr;
    [self.dataArr addObjectsFromArray:sizeArr];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBPlateCell *cell = [RBPlateCell createCellByTableView:tableView];
    RBAiDataModel * aiDataModel = self.dataArr[indexPath.row];
    aiDataModel.type = 1;
    if(indexPath.row %2 == 0){
        aiDataModel.bgColor = [UIColor whiteColor];
    }else{
         aiDataModel.bgColor = [UIColor colorWithSexadeString:@"#F5F5F5"];
    }
    
    cell.aiDataModel =  aiDataModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 37)];
    headView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    NSArray *array = @[@"公司", @"主", @"初盘", @"客", @"主", @"即时盘", @"客"];
    CGFloat width = (RBScreenWidth - 49 - 65) / (array.count - 1);
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        if (i == 0) {
            label.frame = CGRectMake(24 + i * width, 16, 65, 17);
        } else {
            label.frame = CGRectMake(24 + i * width + (65 - width), 16, width, 17);
        }
        label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        if (i == 0) {
            label.textAlignment = NSTextAlignmentLeft;
        } else if (i == 6) {
            label.textAlignment = NSTextAlignmentRight;
        }
        [headView addSubview:label];
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37;
}



@end
