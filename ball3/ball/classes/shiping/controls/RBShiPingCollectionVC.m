#import "RBShiPingCollectionVC.h"
#import "RBShiPingFlowLayout.h"
#import "RBShiPingCollectionCell.h"
#import "RBCollectionViewHead.h"

@interface RBShiPingCollectionVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) RBShiPingFlowLayout *flowLayout;
@end

@implementation RBShiPingCollectionVC

- (RBShiPingFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[RBShiPingFlowLayout alloc]init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(8, 7, 8, 7);
        _flowLayout.footerReferenceSize = CGSizeMake(RBScreenWidth, 65);
    }
    return _flowLayout;
}

- (instancetype)init {
    return [self initWithCollectionViewLayout:self.flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        reuseIdentifier = @"foot";
    }
    RBCollectionViewHead *view = (RBCollectionViewHead *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (view  == nil) {
        view  = [[RBCollectionViewHead alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 65)];
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        view.backgroundColor = [UIColor lightGrayColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, RBScreenWidth, 17)];
        lab.text = @"全部加载完毕啦～";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        [view addSubview:lab];
    }
    return (UICollectionReusableView*)view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(RBScreenWidth, 65);
}
@end
