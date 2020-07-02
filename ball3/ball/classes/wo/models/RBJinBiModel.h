#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBJinBiModel : NSObject
@property (nonatomic, assign) int CreateT;
@property (nonatomic, copy) NSString *Dealno;
@property (nonatomic, assign) int Gold;
@property (nonatomic, assign) int Money;
@property (nonatomic, assign) int State; // 1.未付款 2.已付款
@property(nonatomic,assign)int Paytype;
@property(nonatomic,assign)int Dealtype;
@end

NS_ASSUME_NONNULL_END
