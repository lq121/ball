#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiDatailCellModel : NSObject
@property (nonatomic, copy) NSString *dataTime;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *team1Name;
@property (nonatomic, copy) NSString *team2Name;
@property (nonatomic, assign) int hostAllScore;
@property (nonatomic, assign) int hostHalfScore;
@property (nonatomic, assign) int visitingAllScore;
@property (nonatomic, assign) int visitingHalfScore;
@property (nonatomic, copy) NSString *dish;
@property (nonatomic, copy) NSString *currentHostName;
@property (nonatomic, copy) NSString *currentVisitingName;
@property(nonatomic,assign)int type;
@end

NS_ASSUME_NONNULL_END
