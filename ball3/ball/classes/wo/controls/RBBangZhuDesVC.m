#import "RBBangZhuDesVC.h"
#import "RBLiuYanVC.h"
#import "RBChekLogin.h"
#import "RBFanKuiDesCell.h"

@interface RBBangZhuDesVC ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *isExpandArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *detailArray;

@end

@implementation RBBangZhuDesVC
 -(NSMutableArray *)isExpandArray {
    if (_isExpandArray == nil) {
        _isExpandArray = [NSMutableArray array];
    }
    return _isExpandArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH - 44)];
    tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

    self.provinceArray = @[@"为什么我的账号被封禁？", @"遇到bug，数据错，卡顿等怎么办?", @"充值未到账怎么办？"];
    self.detailArray = @[@"尊敬的用户您好：\n随着平台用户日益增多，部分用户使用小应体育APP的互动行为可能造成自己小应体育号被封停的情况，为更好更快捷的为您提供服务，我们为您开通了账号服务邮箱通道，任何账号相关问题（封禁、禁言等）以后都通过下列邮箱进行咨询申诉，同时也欢迎大家提出自己意见和建议，感谢您对于小应体育的支持！\n邮箱地址：2484275675@qq.com\n将下列信息和材料发送此邮箱，工作人员会在1-2个工作日内进行审核处理，格式不对或者材料不全将不予受理。\n申请格式及所需资料：（必填）\n昵称：（申诉账户的昵称）\n手机号码：（申诉账户对应的手机号码）\n用户姓名：（实名认证时所填写的姓名）\n身份证信息：（实名认证时所填写的身份证前四位+后四位数字）\n问题描述：（例如账号被封、账号被禁言等）\n详细原因：（如果不清楚填“无”）", @"不好意思影响了您的正常使用！麻烦点击底部“点击这里进行反馈”；进行详细描述一下您遇到的问题，并且留下QQ等联系方式，我们会及时进行处理。", @"不好意思影响了您的正常使用，正常购买会员或者充值有可能会存在一定的延迟，如果没有及时到账，建议您稍稍等待一下。\n如果等待之后依然没有到账，麻烦联系官方客服QQ：2484275675，我们工作人员会立即帮您人工核查、处理。"];
    for (NSInteger i = 0; i < _provinceArray.count; i++) {
        if (self.selectItem == i) {
            [self.isExpandArray addObject:@"1"];
        } else {
            [self.isExpandArray addObject:@"0"];//0:没展开 1:展开
        }
    }
    UIButton *otherBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH - 44, RBScreenWidth, 44)];
    [otherBtn addTarget:self action:@selector(clickOtherBtn) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.backgroundColor = [UIColor whiteColor];
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:otherBtn];
    [otherBtn setTitleColor:[UIColor colorWithSexadeString:@"#FA7268"] forState:UIControlStateNormal];
    [otherBtn setTitle:@"咨询其他问题，请留言" forState:UIControlStateNormal];
    CGSize size = [@"咨询其他问题，请留言" getLineSizeWithFontSize:14];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_Arrow"]];
    icon.frame = CGRectMake(size.width + (RBScreenWidth - size.width) * 0.5 + 4, 17, 12, 12);
    [otherBtn addSubview:icon];
}

- (void)clickOtherBtn {
    if ( [RBChekLogin CheckLogin]) {
        return;
    }
    [self.navigationController pushViewController:[[RBLiuYanVC alloc]init] animated:YES];
}

#pragma-- mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.isExpandArray[self.selectItem]isEqualToString:@"1"]) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.detailArray[self.selectItem];
    CGSize size = [str getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64];
    return size.height + 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *provinceLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 19, 300, 22)];
    provinceLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    provinceLabel.font = [UIFont systemFontOfSize:16];
    provinceLabel.textAlignment = NSTextAlignmentLeft;
    provinceLabel.text = _provinceArray[self.selectItem];
    [headerView addSubview:provinceLabel];
    headerView.tag = section;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBFanKuiDesCell *cell = [RBFanKuiDesCell createCellByTableView:tableView];
    cell.des = self.detailArray[self.selectItem];
    return cell;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.isExpandArray[self.selectItem] isEqualToString:@"0"]) {
        [self.isExpandArray replaceObjectAtIndex:self.selectItem withObject:@"1"];
    } else {
        //展开 => 关闭
        [self.isExpandArray replaceObjectAtIndex:self.selectItem withObject:@"0"];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}
@end
