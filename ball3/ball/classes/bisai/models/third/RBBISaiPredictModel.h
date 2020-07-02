#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBBISaiPredictModel : NSObject
@property (copy, nonatomic) NSString *titleName;
@property (copy, nonatomic) NSString *desTitle;
@property (nonatomic, assign) CGFloat win;
@property (nonatomic, assign) CGFloat flat;
@property (nonatomic, assign) CGFloat negative;
@property (nonatomic, assign) BOOL noData;
@property (nonatomic, assign) int status; // 1.未购买 2.购买 3.已完结
@property (nonatomic, assign) int coin;
@property (nonatomic, assign) int zhunqueType; // 1：准，2：错， 3：走
@property (assign, nonatomic, readwrite) BOOL showLine;
@end

NS_ASSUME_NONNULL_END
