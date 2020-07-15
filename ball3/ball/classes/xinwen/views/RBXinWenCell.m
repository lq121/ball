#import "RBXinWenCell.h"
#import "RBBannerView.h"
#import "RBXinWenModel.h"
#import "RBXinWenBigCell.h"
#import "RBXinWenSmallCell.h"
#import "RBXinWenDetailTabVC.h"
#import "RBXinWenListTabVC.h"

@interface RBXinWenCell ()<UITableViewDataSource, UITableViewDelegate, BannerDataSource, BannerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RBBannerView *bannerView;
@end

@implementation RBXinWenCell
- (RBBannerView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [[RBBannerView alloc]initWithFrame:CGRectMake(0, 32, RBScreenWidth, 331)];
        _bannerView.delegate = self;
        _bannerView.datasource = self;
        _bannerView.showPageCotl = YES;
    }
    return _bannerView;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBXinWenCell";
    RBXinWenCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setXinWenArr:(NSArray *)xinWenArr {
    _xinWenArr = xinWenArr;
    int bigNum = (int)(xinWenArr.count - 4) / 4;
    CGFloat height = 0;
    for (int i = 3; i < xinWenArr.count; i++) {
        if ((i - 2) % 4 == 0 && i != 2) {
            RBXinWenModel *model = xinWenArr[i];
            height += (259 + [model.title getSizeWithFontSize:18 andMaxWidth:RBScreenWidth - 24].height);
            continue;
        }
    }
    [self.bannerView removeFromSuperview];
    [self addSubview:self.bannerView];
    [self.bannerView reloadData];
    self.tableView.frame = CGRectMake(0, 371, RBScreenWidth, height + (xinWenArr.count - bigNum - 3) * 116);
    [self.tableView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 371)];
        UIImageView *icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:@"jian"];
        icon.frame = CGRectMake(16, 16, 16, 16);
        [titleView addSubview:icon];

        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = @"小应推荐";
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 8, 16, 80, 16);
        [titleView addSubview:label];

        UIButton *moreBtn = [[UIButton alloc]init];
        [moreBtn addTarget:self  action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
         [moreBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        moreBtn.frame = CGRectMake(RBScreenWidth - 52, 5, 40, 40);
        [titleView addSubview:moreBtn];
        [self addSubview:titleView];

        [self addSubview:self.bannerView];
        [self.bannerView reloadData];

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), RBScreenWidth, 8)];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [titleView addSubview:line];

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
    }
    return self;
}

- (NSInteger)numberOfCellForBannerView:(RBBannerView *)bannerView {
    if (self.xinWenArr.count >= 3) {
        return 3;
    } else {
        return self.xinWenArr.count;
    }
}

- (UIView *)bannerView:(RBBannerView *)bannerView cellForIndex:(NSInteger)index {
    RBXinWenBigCell *xinwenBigCell = [[RBXinWenBigCell alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 298)];
    xinwenBigCell.xinWenModel = self.xinWenArr[index];
    return xinwenBigCell;
}

- (void)bannerView:(RBBannerView *)bannerView didSelectedIndex:(NSInteger)index {
    RBXinWenDetailTabVC *xinWenDetailTabVC = [[RBXinWenDetailTabVC alloc]init];
    xinWenDetailTabVC.xinWenModel = self.xinWenArr[index];
    [[UIViewController getCurrentVC].navigationController pushViewController:xinWenDetailTabVC animated:YES];
}

- (void)clickMoreBtn {
    RBXinWenListTabVC *xinWenListTabVC = [[RBXinWenListTabVC alloc]init];
    [[UIViewController getCurrentVC].navigationController pushViewController:xinWenListTabVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xinWenArr.count - 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ((indexPath.row + 1) % 4 == 0) {
        RBXinWenBigCell *bigCell = [RBXinWenBigCell createCellByTableView:tableView];
        bigCell.xinWenModel = self.xinWenArr[indexPath.row + 3];
        cell = bigCell;
    } else {
        RBXinWenSmallCell *smallCell = [RBXinWenSmallCell createCellByTableView:tableView];
        smallCell.xinwenModel = self.xinWenArr[indexPath.row + 3];
        cell = smallCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row + 1) % 4 == 0) {
        RBXinWenModel *model = self.xinWenArr[indexPath.row + 3];
        return 259 + [model.title getSizeWithFontSize:18 andMaxWidth:RBScreenWidth - 24].height;
    } else {
        return 116;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBXinWenDetailTabVC *xinWenDetailTabVC = [[RBXinWenDetailTabVC alloc]init];
    xinWenDetailTabVC.xinWenModel = self.xinWenArr[indexPath.row + 3];
    [[UIViewController getCurrentVC].navigationController pushViewController:xinWenDetailTabVC animated:YES];
}

@end
