#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBAiDataModel : NSObject
@property (nonatomic, assign) int companyId;
/// 公司
@property (nonatomic, copy) NSString *company;
// 初盘 主
@property (nonatomic, assign) double firstHostBall;
// 初盘 盘口
@property (nonatomic, assign) double firstCenterBall;
// 初盘 客
@property (nonatomic, assign) double firstVisiterBall;
// 即时盘 主
@property (nonatomic, assign) double secondHostBall;
// 即时盘 盘口
@property (nonatomic, assign) double secondCenterBall;
// 即时盘 客
@property (nonatomic, assign) double secondVisiterBall;
// 背景颜色
@property(nonatomic,strong)UIColor *bgColor;
@property(nonatomic,assign)int type;
@end

NS_ASSUME_NONNULL_END
