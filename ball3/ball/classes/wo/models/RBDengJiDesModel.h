#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBDengJiDesModel : NSObject
@property (assign, nonatomic, readwrite) int ID;
@property (assign, nonatomic, readwrite) int grade;
@property (nonatomic, strong) UIColor *bgColor;
@property (assign, nonatomic, readwrite) int experience;
@property (copy, nonatomic) NSString *textColor;
@end

NS_ASSUME_NONNULL_END
