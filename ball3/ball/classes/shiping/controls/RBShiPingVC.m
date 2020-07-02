#import "RBShiPingVC.h"
#import "RBNetworkTool.h"
#import "RBShiPingModel.h"
#import "RBShiPingCollectionVC.h"
#import "RBShiPingCollectionCell.h"
#import "RBCollectionViewHead.h"
#import "RBHengShiPingVC.h"
#import "RBShuShiPingVC.h"

@interface RBShiPingVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSMutableArray *shiPingArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation RBShiPingVC
- (NSMutableArray *)shiPingArr {
    if (_shiPingArr == nil) {
        _shiPingArr = [NSMutableArray array];
    }
    return _shiPingArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = 0;
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    RBShiPingCollectionVC *shiPingCollectionVC = [[RBShiPingCollectionVC alloc]init];
    [self addChildViewController:shiPingCollectionVC];
    UICollectionView *collectionView = shiPingCollectionVC.collectionView;
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.frame = CGRectMake(5, RBStatusBarH, RBScreenWidth - 10, RBScreenHeight - RBStatusBarH - RBTabBarH);
    collectionView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [collectionView registerClass:[RBShiPingCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([RBShiPingCollectionCell class])];
    [collectionView registerClass:[RBCollectionViewHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.view addSubview:collectionView];
    // 获取视频数据
    [self getShiPingData];
}

- (void)getShiPingData {
    // 获取热门推荐
    [MBProgressHUD showLoading:@"加载中..." toView:self.view];
    NSDictionary *dict1 = @{ @"startId": @(self.pageSize), @"endId": @(self.pageSize + 10) };
    self.pageSize += 10;
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getgamevideolist" andParam:dict1 Success:^(NSDictionary *_Nonnull backData) {
        [MBProgressHUD hidHUDFromView:self.view];
        if (backData[@"ok"] != nil) {
            NSDictionary *dic = backData;
            NSArray *array = dic[@"ok"][@"data"];
            [self.shiPingArr addObjectsFromArray:[RBShiPingModel mj_objectArrayWithKeyValuesArray:array]];
            [self.collectionView reloadData];
        }
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hidHUDFromView:self.view];
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shiPingArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RBShiPingCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBShiPingCollectionCell class]) forIndexPath:indexPath];
    cell.shiPingModel = self.shiPingArr[indexPath.row];
    return cell;
}

//每个视图的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (RBScreenWidth - 31) / 2.0;
    RBShiPingCollectionCell *cell = [[RBShiPingCollectionCell alloc]init];
    cell.shiPingModel =  self.shiPingArr[indexPath.row];
    return CGSizeMake(width, cell.cellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RBShiPingModel *videoModel = self.shiPingArr[indexPath.row];
    if (videoModel.Heng == 1) {
        // 横版
        RBHengShiPingVC *hengShiPingVC = [[RBHengShiPingVC alloc]init];
        hengShiPingVC.shiPingModel = self.shiPingArr[indexPath.row];
        [self.navigationController pushViewController:hengShiPingVC animated:YES];
    } else {
        // 竖版
        RBShuShiPingVC *shuShiPingVC = [[RBShuShiPingVC alloc]init];
        shuShiPingVC.shiPingModel = self.shiPingArr[indexPath.row];
        [self.navigationController pushViewController:shuShiPingVC animated:YES];
    }
}

@end
