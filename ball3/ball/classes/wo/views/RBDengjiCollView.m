#import "RBDengjiCollView.h"
#import "RBDengjiCollCell.h"


typedef void (^ClickItem)(NSInteger);
@interface RBDengjiCollView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSArray *models;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) ClickItem clickItem;
@end


@implementation RBDengjiCollView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout andmodels:(NSArray *)models andClickItem:(void (^)(NSInteger))clickitem {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.models = models;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = NO;
        self.clickItem = clickitem;
    }
    [self registerClass:[RBDengjiCollCell class] forCellWithReuseIdentifier:NSStringFromClass([RBDengjiCollCell class])];
    [self reloadData];
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( (RBScreenWidth - 34 - 8) / 2, 97);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RBDengjiCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RBDengjiCollCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.item;
    self.clickItem(_currentIndex);
    [self reloadData];
}

@end
