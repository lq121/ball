#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiModel : NSObject
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int namiId; // 纳米Id
@property (nonatomic, assign) int matcheventId; // 赛事ID
@property (nonatomic, assign) int hostID;
@property (nonatomic, assign) int visitingID;
@property (nonatomic, copy) NSString *hostTeamName; // 主队名称
@property (nonatomic, copy) NSString *visitingTeamName; // 客队名称
@property (nonatomic, assign) int biSaiTime;
@property (nonatomic, assign) int TeeTime;
@property (nonatomic, copy) NSString *TeeTimeStr; // 开球时间
@property (nonatomic, copy) NSString *eventName;  // 赛事名称
@property (nonatomic, copy) NSString *eventLongName;
@property (nonatomic, assign) int eventId;
@property (nonatomic, copy) NSString *stageName;  // 阶段名称
@property (nonatomic, assign) int hostCorner; // 主队角球
@property (nonatomic, assign) int visitingCorner; // 客队角球
@property (nonatomic, assign) int hostHalfScore; // 主队半球
@property (nonatomic, assign) int visitingHalfScore; // 客队角球
@property (nonatomic, assign) int hostPointScore; // 主队点球
@property (nonatomic, assign) int visitingPointScore; // 客队点球
@property (nonatomic, assign) int hostScore; //  主队比分
@property (nonatomic, assign) int visitingScore; // 客队比分
@property (nonatomic, assign) int hostRedCard; // 主队红牌
@property (nonatomic, assign) int visitingRedCard; // 客队队红牌
@property (nonatomic, assign) int hostYellowCard; // 主队黄牌
@property (nonatomic, assign) int visitingYellowCard; // 客队黄牌
@property (nonatomic, assign) int hostOvertimeScore; // 主队加时比分
@property (nonatomic, assign) int visitingOvertimeScore; // 客队加时比分
@property (nonatomic, assign) int hostPenaltyScore; // 主队点球比分
@property (nonatomic, assign) int visitingPenaltyScore; // 客队点球比分
@property (nonatomic, copy) NSString *week; // 星期几
@property (nonatomic, assign) int status; // 赛事状态
@property (nonatomic, copy) NSString *hostLogo; // 主队logo
@property (nonatomic, copy) NSString *visitingLogo; // 客队logo
@property (nonatomic, assign) BOOL hasIntelligence;
@property (nonatomic, strong) NSDictionary *stage;
@property (nonatomic, assign) BOOL hasAttention;
@property (nonatomic, assign) int scoreType;
@property(nonatomic,assign)BOOL hasShiPing;
@property(nonatomic,copy)NSString *ballData;

+ (instancetype)getBiSaiModelWithArray:(NSArray *)arr andTeams:(NSDictionary *)teams andEvents:(NSDictionary *)events andStages:(NSDictionary *)stages;

@end

NS_ASSUME_NONNULL_END
