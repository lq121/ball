#import "RBSearchVC.h"
#import "RBNetworkTool.h"
#import "RBBiSaiModel.h"
#import "RBResultCell.h"
#import "RBBiSaiDetailVC.h"
#import "RBFMDBTool.h"
#import "RBLoginVC.h"

@interface RBSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *searchStr;
@property(nonatomic,strong)UILabel *tipLab;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation RBSearchVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor colorWithSexadeString:@"#F8F8F8"]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 24, RBScreenWidth, RBScreenHeight-RBNavBarAndStatusBarH-24) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView  =tableView;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 24)];
    tipLab.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268" AndAlpha:0.1];
    tipLab.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.text = jinggongjintian;
    self.tipLab = tipLab;
    [self.view addSubview:tipLab];
    
    //消除阴影
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, RBScreenWidth - 40 - 32, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    UIImageView *searchImage = [[UIImageView alloc]init];
    [searchImage setImage:[UIImage imageNamed:@"search2"]];
    searchImage.frame = CGRectMake(0, 4, 32, 32);
    [titleView addSubview:searchImage];

    UITextField *textField = [[UITextField alloc]init];
    [textField becomeFirstResponder];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType =  UIReturnKeySearch;
    textField.font = [UIFont systemFontOfSize:16];
    textField.placeholder = lainsaiqiudui;
    textField.tintColor = [UIColor colorWithSexadeString:@"#FFA500"];
    textField.textColor = [UIColor colorWithSexadeString:@"#333333"];
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.frame = CGRectMake(32, 0, RBScreenWidth - 32 - 40 - 32, 40);
    [titleView addSubview:textField];
    self.navigationItem.titleView = titleView;

    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 50)];
    self.cancelBtn = cancelBtn;
    [cancelBtn setTitle:quxiao forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    [self setupHeadView];
}

- (void)setupHeadView {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, RBScreenWidth - 20, 30)];
    titleLabel.text = remenshousuo;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [titleLabel sizeToFit];
    [headView addSubview:titleLabel];

    UIView *tagsView = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(titleLabel.frame) + 16, RBScreenWidth - 32, 120)];
    [headView addSubview:tagsView];

    NSArray *arr = @[@"非洲杯", @"巴西杯", @"新西兰联赛", @"甲联", @"欧洲杯", @"澳威超"];
    self.tagsArray = arr;
    CGFloat allLabelWidth = 0;
    CGFloat allLabelHeight = 0;
    CGFloat margin = 8;
    CGFloat pading = 60;
    int rowHeight = 0;
    for (int i = 0; i < arr.count; i++) {
        if (i != self.tagsArray.count - 1) {
            NSString * str = self.tagsArray[i + 1];
            CGFloat width = [str getLineSizeWithFontSize:14].width + pading;
            if (allLabelWidth + width + margin > tagsView.width) {
                rowHeight++;
                allLabelWidth = 0;
                allLabelHeight = rowHeight * 40;
            }
        } else {
            NSString * str = self.tagsArray[self.tagsArray.count - 1];
            CGFloat width = [str getLineSizeWithFontSize:14].width + pading;
            if (allLabelWidth + width + margin > tagsView.width) {
                rowHeight++;
                allLabelWidth = 0;
                allLabelHeight = rowHeight * 40;
            }
        }
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.font = [UIFont systemFontOfSize:14];
        tagLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tagLabel.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        tagLabel.text = self.tagsArray[i];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
        [tagLabel addGestureRecognizer:labelTapGestureRecognizer];
        NSString * str = self.tagsArray[i];
        CGFloat labelWidth = [str getLineSizeWithFontSize:14].width + pading;
        tagLabel.layer.cornerRadius = 16;
        [tagLabel.layer setMasksToBounds:YES];
        tagLabel.frame = CGRectMake(allLabelWidth, allLabelHeight, labelWidth, 32);
        [tagsView addSubview:tagLabel];
        allLabelWidth = allLabelWidth + margin + labelWidth;
    }
    tagsView.height = rowHeight * 40 + 40;
    headView.frame = CGRectMake(0, 0, RBScreenWidth, CGRectGetMaxY(tagsView.frame) + 10);
    self.tableView.tableHeaderView = headView;
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    UILabel *label = (UILabel *)recognizer.view;
    self.searchStr = label.text;
    [self loadData];
}

- (void)clickCancel:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.searchStr = textField.text;
    [self loadData];
    return YES;
}

- (void)loadData {
    [MBProgressHUD showLoading:jiazhaizhong toView:self.tableView];
    NSMutableArray *array = [[RBFMDBTool sharedFMDBTool]selectBiSaiModelWithStr:self.searchStr];
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:array];
    if (self.dataArr != nil && self.dataArr.count != 0) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 48)];
        headView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, RBScreenWidth - 20, 48)];
        titleLabel.text = saishi;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [headView addSubview:titleLabel];
        self.tableView.tableHeaderView = headView;
        int timet = [[NSDate date]timeIntervalSince1970];
        self.tipLab.text = [NSString stringWithFormat:@"%@ %@",[NSString getStrWithDate:[NSDate date] andFormat:@"yyyy年MM月dd日"],[NSString weekdayStringFromDate:timet]];
    } else {
        self.tipLab.text = jinggongjintian;
        self.tableView.tableHeaderView = nil;
    }
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBResultCell *cell = [RBResultCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.biSaiModel = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBBiSaiModel *model = self.dataArr[indexPath.row];
    if (model.status<2 || model.status >7) {
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        if (uid == nil || [uid isEqualToString:@""] ) {
            RBLoginVC *loginVC = [[RBLoginVC alloc]init];
            loginVC.fromVC = self;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }else{
            RBBiSaiDetailVC *detailVC = [[RBBiSaiDetailVC alloc]init];
            detailVC.biSaiModel = model;
            [self.navigationController pushViewController:detailVC animated:YES];  
        }
    }else{
        RBBiSaiDetailVC *detailVC = [[RBBiSaiDetailVC alloc]init];
        detailVC.biSaiModel = model;
        [self.navigationController pushViewController:detailVC animated:YES];        
    }
}





@end
