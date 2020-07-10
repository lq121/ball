#import <Foundation/Foundation.h>
#import "RBXiaoXiModel.h"
#import "RBBiSaiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBFMDBTool : NSObject
//单例实现
+ (instancetype)sharedFMDBTool;
- (void)openDatabase;

/// 删除消息表
- (void)dropMsgTab;
/// 创建消息表
- (void)createMagTab;
/// 添加消息
- (void)addMsgModel:(RBXiaoXiModel *)model;
/// 删除消息
- (void)delelteMsgWithId:(int)Id;
/// 根据type 查询消息
- (NSMutableArray *)selectMsgModelWithType:(int)type;

/// 删除关注表
- (void)dropAttentionTab;
/// 创建关注列表
- (void)createAttentionTab;
///  添加关注
- (void)addAttentionBiSaiModel:(RBBiSaiModel *)model;
/// 更新关注
- (void)updateAttentionBiSaiModel:(RBBiSaiModel *)model;
/// 删除关注
- (void)deleteLastAttentionData;
/// 通过id删除关注
- (void)deleteAttentionBiSaiModelWithId:(int)Id;
/// 根据id查询关注
- (BOOL)selectAttentionBiSaiModelWithId:(int)Id;
/// 根据时间查询关注列表
- (NSMutableArray *)selectAttentionBiSaiModelWithTime:(int)time;

/// 删除比赛数据表
- (void)dropBiSaiTab;
/// 创建比赛数据表
- (void)createBiSaiTab;
/// 添加比赛数据
- (void)addBiSaiModel:(RBBiSaiModel *)model;
/// 更新比赛数据
- (void)updateBiSaiModel:(RBBiSaiModel *)model;
/// 删除比赛数据
- (void)deleteBiSaiModelWithId:(int)Id;
/// 根据ID查询比赛数据是否存在
- (BOOL)selectBiSaiModelWithId:(int)Id;
/// 根据ID查询比赛数据
- (RBBiSaiModel *)selectBiSaiModelWithNamiId:(int)Id;
/// 根据时间和比赛状态查询对应的比赛列表数据
- (NSMutableArray *)selectBiSaiModelWithTime:(int)time andMinStatus:(int)minStatus andMaxStatus:(int)maxStatus;
/// 模糊查询比赛数据
- (NSMutableArray *)selectBiSaiModelWithStr:(NSString *)str;
/// 删除以前比赛数据
- (void)deleteLongTimeBiSaiModel;
// 删除今天比赛
- (void)deleteTadayBiSaiModel;
- (void)insertBiSaisUseTransaction:(NSArray<RBBiSaiModel *> *)biSais;
@end

NS_ASSUME_NONNULL_END
