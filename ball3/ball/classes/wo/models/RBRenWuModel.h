#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBRenWuModel : NSObject
@property (nonatomic, assign) int Id;
@property (nonatomic, assign) int Style;
@property (nonatomic, assign) int Num;
@property (nonatomic, assign) int Addcoin;
@property (nonatomic, assign) int Addexp;
@property (nonatomic, assign) int Allnum; //总的限制次数，-1为不限制
@property (nonatomic, assign) int Daynum; //每日限制次数，-1为不限制
@property (nonatomic, assign) int Everytimerd;//是否每次领取，0表示达到限制次数再领取
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *tip;
@property(nonatomic,copy)NSString *btnTitle;
@end

NS_ASSUME_NONNULL_END
