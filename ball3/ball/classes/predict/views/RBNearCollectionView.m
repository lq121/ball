#import "RBNearCollectionView.h"
#import "RBNetworkTool.h"
#import "RBNearCollectionCell.h"

typedef void (^ClickItem)(NSInteger);
@interface RBNearCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSArray *models;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) ClickItem clickItem;
@end

@implementation RBNearCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout andmodels:(NSArray *)models andClickItem:(void (^)(NSInteger))clickitem {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.models = models;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = YES;
        self.clickItem = clickitem;
    }
    [self registerClass:[RBNearCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([RBNearCollectionCell class])];
    [self reloadData];
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(182, 97);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 4, 0, 0);//分别为上、左、下、右
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RBNearCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBNearCollectionCell class]) forIndexPath:indexPath];
    cell.predictModel = self.models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.item;
    self.clickItem(_currentIndex);
    [self reloadData];
}

#pragma mark 访客记录数据加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //检测左测滑动,开始加载更多
    if (scrollView.contentOffset.x + scrollView.width - scrollView.contentSize.width > -30) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getMoreJiYuce" object:nil];
    }
}

@end
