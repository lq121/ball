#import "RBBaseTabVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiTabVC : RBBaseTabVC
@property(nonatomic,assign)int biSaiType;
@property(nonatomic,assign)int date;
- (void)getLocalBiSaiData;
@property (nonatomic, assign) BOOL hasSelect;
@end

NS_ASSUME_NONNULL_END
