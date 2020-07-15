#import "RBFMDBTool.h"
#import "FMDB.h"
@interface RBFMDBTool ()
@property (nonatomic, strong) FMDatabase *fmdb;
@end

@implementation RBFMDBTool
+ (instancetype)sharedFMDBTool {
    static RBFMDBTool *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[RBFMDBTool alloc] init];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];//获取沙河地址
        NSString *fileName = [docPath stringByAppendingPathComponent:@"spots.sqlite"];//设置数据库名称
        Instance.fmdb = [FMDatabase databaseWithPath:fileName];//创建并获取数据库信息
    });
    return Instance;
}

- (void)openDatabase {
    [self.fmdb open];
}

# pragma-mark 消息表

- (void)dropMsgTab {
    if (self.fmdb.close) {
        [self.fmdb open];
    }
    [self.fmdb executeUpdate:@"DROP TABLE  if exists tb_msg;"];
}

- (void)createMagTab {
    [self.fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_msg (Id integer PRIMARY KEY AUTOINCREMENT, uid varchar(70) NOT NULL, t integer NOT NULL, title varchar(100), txt varchar(1000), type integer NOT NULL);"];
}

- (void)addMsgModel:(RBXiaoXiModel *)msgModel {
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [self.fmdb executeUpdate:@"INSERT INTO tb_msg (uid,t, title, txt,type) VALUES (?,?,?,?,?)", uid, @(msgModel.t), msgModel.title, msgModel.txt, @(msgModel.type)];
}

- (void)delelteMsgWithId:(int)Id {
    [self.fmdb executeUpdate:@"delete from tb_msg where id = ?", @(Id)];//按照id进行删除
}

- (NSMutableArray *)selectMsgModelWithType:(int)type {
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    FMResultSet *resultSet = [self.fmdb executeQuery:@"select * from tb_msg where (type = ? and uid = ?) order by t desc", @(type), uid];
    NSMutableArray *array = [NSMutableArray array];
    while ([resultSet next]) {
        RBXiaoXiModel *msgModel = [[RBXiaoXiModel alloc]init];
        msgModel.type = type;
        msgModel.t = [resultSet intForColumn:@"t"];
        msgModel.title = (NSString *)([resultSet objectForColumnName:@"title"]);
        msgModel.txt = (NSString *)([resultSet objectForColumnName:@"txt"]);
        msgModel.Id = [resultSet intForColumn:@"id"];
        [array addObject:msgModel];
    }
    return array;
}

#pragma-mark 关注表
- (void)dropAttentionTab {
    if (self.fmdb.close) {
        [self.fmdb open];
    }
    [self.fmdb executeUpdate:@"DROP TABLE  if exists tb_attentionBiSai;"];
}

- (void)createAttentionTab {
    //    PRIMARY KEY AUTOINCREMENT 基键 并且自增
    [self.fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_attentionBiSai (namiId integer PRIMARY KEY, id integer,uid varchar(70) NOT NULL,matcheventId integer NOT NULL, hostID integer , visitingID integer ,hostTeamName varchar(50),visitingTeamName varchar(50),biSaiTime integer ,TeeTime integer,eventName varchar(50),eventLongName varchar(100), eventId integer , stageName varchar(100),hostCorner integer , visitingCorner integer , hostHalfScore integer , visitingHalfScore integer,hostPointScore integer, visitingPointScore integer, hostScore integer,visitingScore integer, hostRedCard integer, visitingRedCard integer, hostYellowCard integer, visitingYellowCard integer, hostOvertimeScore integer, visitingOvertimeScore integer, hostPenaltyScore integer, visitingPenaltyScore integer, week varchar(50), status integer, hostLogo varchar(250),visitingLogo varchar(250),hasIntelligence BOOL,stage varchar(500),hasAttention BOOL ,hasshiping BOOL,ballData varchar(300));"];
}

- (void)addAttentionBiSaiModel:(RBBiSaiModel *)model {
    NSString *dataStr;
    if (model.stage != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model.stage options:0 error:0];
        dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        return;
    }
    [self.fmdb executeUpdate:@"INSERT INTO tb_attentionBiSai (namiId,id,uid, matcheventId, hostID,visitingID,hostTeamName,visitingTeamName,biSaiTime,TeeTime,eventName,eventLongName, eventId,stageName,hostCorner,visitingCorner,hostHalfScore,visitingHalfScore,hostPointScore,visitingPointScore,hostScore,visitingScore,hostRedCard,visitingRedCard,hostYellowCard,visitingYellowCard,hostOvertimeScore,visitingOvertimeScore,hostPenaltyScore,visitingPenaltyScore,week,status,hostLogo,visitingLogo,hasIntelligence,stage,hasAttention,hasshiping,ballData ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", @(model.namiId), @(model.index), uid, @(model.matcheventId), @(model.hostID), @(model.visitingID), model.hostTeamName, model.visitingTeamName, @(model.biSaiTime), @(model.TeeTime), model.eventName, model.eventLongName, @(model.eventId), model.stageName, @(model.hostCorner), @(model.visitingCorner), @(model.hostHalfScore), @(model.visitingHalfScore), @(model.hostPointScore), @(model.visitingPointScore), @(model.hostScore), @(model.visitingScore), @(model.hostRedCard), @(model.visitingRedCard), @(model.hostYellowCard), @(model.visitingYellowCard), @(model.hostOvertimeScore), @(model.visitingOvertimeScore), @(model.hostPenaltyScore), @(model.visitingPenaltyScore), model.week, @(model.status), model.hostLogo, model.visitingLogo, @(model.hasIntelligence), dataStr, @(model.hasAttention), @(model.hasShiPing),model.ballData];
}



- (void)updateAttentionBiSaiModelWithNamiId:(int)namiId andBallData:(NSString *)ballData {
    [self.fmdb executeUpdate:@"update tb_attentionBiSai set  ballData = ? where namiId = ?", ballData, @(namiId)];
}
- (void)updateAttentionBiSaiModelWithNamiId:(int)namiId andhasShiPing:(BOOL)hasShiPing{
    [self.fmdb executeUpdate:@"update tb_attentionBiSai set  hasshiping = ? where namiId = ?", [NSNumber numberWithBool:hasShiPing], @(namiId)];
}
- (void)updateAttentionBiSaiModel:(RBBiSaiModel *)model {
    NSString *dataStr;
    if (model.stage != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model.stage options:0 error:0];
        dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    [self.fmdb executeUpdate:@"update tb_attentionBiSai set  matcheventId = ?, hostID = ?,visitingID = ?,hostTeamName = ?,visitingTeamName = ?,biSaiTime = ?,TeeTime = ?,eventName = ?,eventLongName = ?,eventId = ?,stageName = ?,hostCorner = ?,visitingCorner = ?,hostHalfScore = ?,visitingHalfScore = ?,hostPointScore = ?,visitingPointScore = ?,hostScore = ?,visitingScore = ?,hostRedCard = ?,visitingRedCard = ?,hostYellowCard = ?,visitingYellowCard = ?,hostOvertimeScore = ?,visitingOvertimeScore = ?,hostPenaltyScore = ?,visitingPenaltyScore = ?,week = ?,status = ?,hostLogo = ?,visitingLogo = ?,hasIntelligence = ?,stage = ?,hasAttention = ?, hasshiping = ?,ballData=? where namiId = ?", @(model.matcheventId), @(model.hostID), @(model.visitingID), model.hostTeamName, model.visitingTeamName, @(model.biSaiTime), @(model.TeeTime), model.eventName, model.eventLongName, @(model.eventId), model.stageName, @(model.hostCorner), @(model.visitingCorner), @(model.hostHalfScore), @(model.visitingHalfScore), @(model.hostPointScore), @(model.visitingPointScore), @(model.hostScore), @(model.visitingScore), @(model.hostRedCard), @(model.visitingRedCard), @(model.hostYellowCard), @(model.visitingYellowCard), @(model.hostOvertimeScore), @(model.visitingOvertimeScore), @(model.hostPenaltyScore), @(model.visitingPenaltyScore), model.week, @(model.status), model.hostLogo, model.visitingLogo, @(model.hasIntelligence), dataStr, @(model.hasAttention), @(model.hasShiPing),model.ballData, @(model.namiId)];
}

- (void)deleteLastAttentionData {
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:([components day] - 4)];
    NSDate *yesterday = [gregorian dateFromComponents:components];
    [self.fmdb executeUpdate:@"delete from tb_attentionBiSai where biSaiTime < ?", @((int)[yesterday timeIntervalSince1970])];//按照id进行删除
}

- (void)deleteAttentionBiSaiModelWithId:(int)Id {
    [self.fmdb executeUpdate:@"delete from tb_attentionBiSai where namiId = ?", @(Id)];//按照id进行删除
}

- (BOOL)selectAttentionBiSaiModelWithId:(int)Id {
    //查询整个表
    FMResultSet *resultSet = [self.fmdb executeQuery:@"select * from tb_attentionBiSai where namiId = ?", @(Id)];
    //遍历结果集合
    return [resultSet next];
}

- (NSMutableArray *)selectAttentionBiSaiModelWithTime:(int)time {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    int last = (int)[startDate  timeIntervalSince1970];
    int next = (int)[endDate  timeIntervalSince1970];
    NSMutableArray *array = [NSMutableArray array];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        return array;
    }

    FMResultSet *resultSet = [self.fmdb executeQuery:@"select * from tb_attentionBiSai where (biSaiTime >= ?) and (biSaiTime < ?) and uid = ?", @(last), @(next), uid];
    while ([resultSet next]) {
        RBBiSaiModel *model = [[RBBiSaiModel alloc]init];
        model.index = [resultSet intForColumn:@"id"];
        model.namiId = [resultSet intForColumn:@"namiId"];
        model.matcheventId = [resultSet intForColumn:@"namiId"];
        model.hostID = [resultSet intForColumn:@"hostID"];
        model.visitingID = [resultSet intForColumn:@"visitingID"];
        model.hostTeamName = (NSString *)([resultSet objectForColumnName:@"hostTeamName"]);
        model.visitingTeamName = (NSString *)[resultSet objectForColumnName:@"visitingTeamName"];
        model.biSaiTime = [resultSet intForColumn:@"biSaiTime"];
        model.TeeTime = [resultSet intForColumn:@"TeeTime"];
        model.eventName = (NSString *)[resultSet objectForColumnName:@"eventName"];
        model.eventLongName = (NSString *)[resultSet objectForColumnName:@"eventLongName"];
        model.ballData = (NSString *)[resultSet objectForColumnName:@"ballData"];
        model.eventId = [resultSet intForColumn:@"eventId"];
        model.stageName = (NSString *)[resultSet objectForColumnName:@"stageName"];
        model.hostCorner = [resultSet intForColumn:@"hostCorner"];
        model.hostHalfScore = [resultSet intForColumn:@"hostHalfScore"];
        model.visitingHalfScore = [resultSet intForColumn:@"visitingHalfScore"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];
        model.visitingPointScore = [resultSet intForColumn:@"visitingPointScore"];
        model.hostScore = [resultSet intForColumn:@"hostScore"];
        model.visitingScore = [resultSet intForColumn:@"visitingScore"];
        model.hostRedCard = [resultSet intForColumn:@"hostRedCard"];
        model.visitingRedCard = [resultSet intForColumn:@"visitingRedCard"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];  model.hostYellowCard = [resultSet intForColumn:@"hostYellowCard"];
        model.visitingYellowCard = [resultSet intForColumn:@"visitingYellowCard"];
        model.hostOvertimeScore = [resultSet intForColumn:@"hostOvertimeScore"];
        model.visitingOvertimeScore = [resultSet intForColumn:@"visitingOvertimeScore"];
        model.hostPenaltyScore = [resultSet intForColumn:@"hostPenaltyScore"];
        model.visitingPenaltyScore = [resultSet intForColumn:@"visitingPenaltyScore"];
        model.week = (NSString *)[resultSet objectForColumnName:@"week"];
        model.status = [resultSet intForColumn:@"status"];
        model.hostLogo = (NSString *)[resultSet objectForColumnName:@"hostLogo"];
        model.hasIntelligence = [resultSet intForColumn:@"hasIntelligence"];
        model.hasShiPing = [resultSet intForColumn:@"hasshiping"];
        model.visitingLogo = (NSString *)[resultSet objectForColumnName:@"visitingLogo"];
        NSString *stage = (NSString *)[resultSet objectForColumnName:@"stage"];
        if (stage != nil && ![stage isKindOfClass:[NSNull class]]) {
            NSData *jsonData = [stage dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            model.stage = dic;
        }
        model.hasAttention = [resultSet intForColumn:@"hasAttention"];

        [array addObject:model];
    }
    return array;
}

#pragma-mark 比赛列表数据
- (void)dropBiSaiTab {
    if (self.fmdb.close) {
        [self.fmdb open];
    }
    [self.fmdb executeUpdate:@"DROP TABLE  if exists tb_bisai;"];
}

- (void)createBiSaiTab {
    //    PRIMARY KEY AUTOINCREMENT 基键 并且自增
    [self.fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_bisai (namiId integer PRIMARY KEY, id integer, matcheventId integer NOT NULL, hostID integer , visitingID integer ,hostTeamName varchar(50),visitingTeamName varchar(50),biSaiTime integer ,TeeTime integer,eventName varchar(50),eventLongName varchar(100), eventId integer , stageName varchar(100),hostCorner integer , visitingCorner integer , hostHalfScore integer , visitingHalfScore integer,hostPointScore integer, visitingPointScore integer, hostScore integer,visitingScore integer, hostRedCard integer, visitingRedCard integer, hostYellowCard integer, visitingYellowCard integer, hostOvertimeScore integer, visitingOvertimeScore integer, hostPenaltyScore integer, visitingPenaltyScore integer, week varchar(50), status integer, hostLogo varchar(250),visitingLogo varchar(250),hasIntelligence BOOL,stage varchar(300),hasAttention BOOL,hasshiping BOOL,ballData varchar(300));"];
}



- (void)insertBiSaisUseTransaction:(NSArray<RBBiSaiModel *> *)biSais {
    [self.fmdb open];
    [self.fmdb beginTransaction];
    BOOL isRollBack = NO;
    @try {
        for (RBBiSaiModel *model in biSais) {
            NSString *dataStr;
            if (model.stage != nil) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model.stage options:0 error:0];
                dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            [self.fmdb executeUpdate:@"INSERT INTO tb_bisai (namiId,id, matcheventId, hostID,visitingID,hostTeamName,visitingTeamName,biSaiTime,TeeTime,eventName,eventLongName,eventId,stageName,hostCorner,visitingCorner,hostHalfScore,visitingHalfScore,hostPointScore,visitingPointScore,hostScore,visitingScore,hostRedCard,visitingRedCard,hostYellowCard,visitingYellowCard,hostOvertimeScore,visitingOvertimeScore,hostPenaltyScore,visitingPenaltyScore,week,status,hostLogo,visitingLogo,hasIntelligence,stage,hasAttention,hasshiping,ballData) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", @(model.namiId), @(model.index), @(model.matcheventId), @(model.hostID), @(model.visitingID), model.hostTeamName, model.visitingTeamName, @(model.biSaiTime), @(model.TeeTime), model.eventName, model.eventLongName, @(model.eventId), model.stageName, @(model.hostCorner), @(model.visitingCorner), @(model.hostHalfScore), @(model.visitingHalfScore), @(model.hostPointScore), @(model.visitingPointScore), @(model.hostScore), @(model.visitingScore), @(model.hostRedCard), @(model.visitingRedCard), @(model.hostYellowCard), @(model.visitingYellowCard), @(model.hostOvertimeScore), @(model.visitingOvertimeScore), @(model.hostPenaltyScore), @(model.visitingPenaltyScore), model.week, @(model.status), model.hostLogo, model.visitingLogo, @(model.hasIntelligence), dataStr, @(model.hasAttention), @(model.hasShiPing), model.ballData];
        }
    } @catch (NSException *exception) {
        isRollBack = YES;
        [self.fmdb rollback];
    } @finally {
        if (!isRollBack) {
            [self.fmdb commit];
        }
    }
}

- (void)addBiSaiModel:(RBBiSaiModel *)model {
    NSString *dataStr;
    if (model.stage != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model.stage options:0 error:0];
        dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    [self.fmdb executeUpdate:@"INSERT INTO tb_bisai (namiId,id, matcheventId, hostID,visitingID,hostTeamName,visitingTeamName,biSaiTime,TeeTime,eventName,eventLongName,eventId,stageName,hostCorner,visitingCorner,hostHalfScore,visitingHalfScore,hostPointScore,visitingPointScore,hostScore,visitingScore,hostRedCard,visitingRedCard,hostYellowCard,visitingYellowCard,hostOvertimeScore,visitingOvertimeScore,hostPenaltyScore,visitingPenaltyScore,week,status,hostLogo,visitingLogo,hasIntelligence,stage,hasAttention,hasshiping,ballData) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", @(model.namiId), @(model.index), @(model.matcheventId), @(model.hostID), @(model.visitingID), model.hostTeamName, model.visitingTeamName, @(model.biSaiTime), @(model.TeeTime), model.eventName, model.eventLongName, @(model.eventId), model.stageName, @(model.hostCorner), @(model.visitingCorner), @(model.hostHalfScore), @(model.visitingHalfScore), @(model.hostPointScore), @(model.visitingPointScore), @(model.hostScore), @(model.visitingScore), @(model.hostRedCard), @(model.visitingRedCard), @(model.hostYellowCard), @(model.visitingYellowCard), @(model.hostOvertimeScore), @(model.visitingOvertimeScore), @(model.hostPenaltyScore), @(model.visitingPenaltyScore), model.week, @(model.status), model.hostLogo, model.visitingLogo, @(model.hasIntelligence), dataStr, @(model.hasAttention), @(model.hasShiPing), model.ballData];
}

- (void)updateBiSaiModelWithNamiId:(int)namiId andhasAttention:(BOOL)hasAttention {
    [self.fmdb executeUpdate:@"update tb_bisai set  hasAttention = ? where namiId = ?", [NSNumber numberWithBool:hasAttention], @(namiId)];
}

- (void)updateBiSaiModelWithNamiId:(int)namiId andBallData:(NSString *)ballData {
    [self.fmdb executeUpdate:@"update tb_bisai set  ballData = ? where namiId = ?", ballData, @(namiId)];
}

- (void)updateBiSaiModelWithNamiId:(int)namiId andhasShiPing:(BOOL)hasShiPing {
    [self.fmdb executeUpdate:@"update tb_bisai set  hasshiping = ? where namiId = ?", [NSNumber numberWithBool:hasShiPing], @(namiId)];
}

- (void)updateBiSaiModel:(RBBiSaiModel *)model {
    NSString *dataStr;
    if (model.stage != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model.stage options:0 error:0];
        dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    [self.fmdb executeUpdate:@"update tb_bisai set  matcheventId = ?, hostID = ?,visitingID = ?,hostTeamName = ?,visitingTeamName = ?,biSaiTime = ?,TeeTime = ?,eventName = ?,eventLongName = ?,eventId = ?,stageName = ?,hostCorner = ?,visitingCorner = ?,hostHalfScore = ?,visitingHalfScore = ?,hostPointScore = ?,visitingPointScore = ?,hostScore = ?,visitingScore = ?,hostRedCard = ?,visitingRedCard = ?,hostYellowCard = ?,visitingYellowCard = ?,hostOvertimeScore = ?,visitingOvertimeScore = ?,hostPenaltyScore = ?,visitingPenaltyScore = ?,week = ?,status = ?,hostLogo = ?,visitingLogo = ?,hasIntelligence = ?,stage = ?,hasAttention = ?,hasshiping=?,ballData=? where namiId = ?", @(model.matcheventId), @(model.hostID), @(model.visitingID), model.hostTeamName, model.visitingTeamName, @(model.biSaiTime), @(model.TeeTime), model.eventName, model.eventLongName, @(model.eventId), model.stageName, @(model.hostCorner), @(model.visitingCorner), @(model.hostHalfScore), @(model.visitingHalfScore), @(model.hostPointScore), @(model.visitingPointScore), @(model.hostScore), @(model.visitingScore), @(model.hostRedCard), @(model.visitingRedCard), @(model.hostYellowCard), @(model.visitingYellowCard), @(model.hostOvertimeScore), @(model.visitingOvertimeScore), @(model.hostPenaltyScore), @(model.visitingPenaltyScore), model.week, @(model.status), model.hostLogo, model.visitingLogo, @(model.hasIntelligence), dataStr, @(model.hasAttention), @(model.hasShiPing), model.ballData, @(model.namiId)];
}

- (void)deleteLongTimeBiSaiModel {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *lastDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-5 toDate:startDate options:0];
    int last = (int)[lastDate  timeIntervalSince1970];
    [self.fmdb executeUpdate:@"delete from tb_bisai where (biSaiTime < ?)", @(last)]; //按照id进行删除
}

- (void)deleteTadayBiSaiModel {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *lastDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    int last = (int)[startDate  timeIntervalSince1970];
    int next = (int)[lastDate  timeIntervalSince1970];
    [self.fmdb executeUpdate:@"delete from tb_bisai where  (biSaiTime >= ?) and (biSaiTime < ?)", @(last), @(next)]; //按照id进行删除
}

- (void)deleteBiSaiModelWithId:(int)Id {
    [self.fmdb executeUpdate:@"delete from tb_bisai where namiId = ?", @(Id)];//按照id进行删除
}

- (BOOL)selectBiSaiModelWithId:(int)Id {
    //查询整个表
    FMResultSet *resultSet = [self.fmdb executeQuery:@"select * from tb_bisai where namiId = ?", @(Id)];
    //遍历结果集合
    return [resultSet next];
}

- (RBBiSaiModel *)selectBiSaiModelWithNamiId:(int)Id {
    //查询整个表
    FMResultSet *resultSet = [self.fmdb executeQuery:@"select * from tb_bisai where namiId = ?", @(Id)];
    //遍历结果集合
    RBBiSaiModel *model = [[RBBiSaiModel alloc]init];
    while ([resultSet next]) {
        model.namiId = [resultSet intForColumn:@"namiId"];
        model.index = [resultSet intForColumn:@"id"];
        model.matcheventId = [resultSet intForColumn:@"namiId"];
        model.hostID = [resultSet intForColumn:@"hostID"];
        model.visitingID = [resultSet intForColumn:@"visitingID"];
        model.hostTeamName = (NSString *)([resultSet objectForColumnName:@"hostTeamName"]);
        model.visitingTeamName = (NSString *)[resultSet objectForColumnName:@"visitingTeamName"];
        model.biSaiTime = [resultSet intForColumn:@"biSaiTime"];
        model.TeeTime = [resultSet intForColumn:@"TeeTime"];
        model.eventName = (NSString *)[resultSet objectForColumnName:@"eventName"];
        model.eventLongName = (NSString *)[resultSet objectForColumnName:@"eventLongName"];
        model.ballData = (NSString *)[resultSet objectForColumnName:@"ballData"];
        model.eventId = [resultSet intForColumn:@"eventId"];
        model.stageName = (NSString *)[resultSet objectForColumnName:@"stageName"];
        model.hostCorner = [resultSet intForColumn:@"hostCorner"];
        model.visitingCorner = [resultSet intForColumn:@"visitingCorner"];
        model.hostHalfScore = [resultSet intForColumn:@"hostHalfScore"];
        model.visitingHalfScore = [resultSet intForColumn:@"visitingHalfScore"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];
        model.visitingPointScore = [resultSet intForColumn:@"visitingPointScore"];
        model.hostScore = [resultSet intForColumn:@"hostScore"];
        model.visitingScore = [resultSet intForColumn:@"visitingScore"];
        model.hostRedCard = [resultSet intForColumn:@"hostRedCard"];
        model.visitingRedCard = [resultSet intForColumn:@"visitingRedCard"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];  model.hostYellowCard = [resultSet intForColumn:@"hostYellowCard"];
        model.visitingYellowCard = [resultSet intForColumn:@"visitingYellowCard"];
        model.hostOvertimeScore = [resultSet intForColumn:@"hostOvertimeScore"];
        model.visitingOvertimeScore = [resultSet intForColumn:@"visitingOvertimeScore"];
        model.hostPenaltyScore = [resultSet intForColumn:@"hostPenaltyScore"];
        model.visitingPenaltyScore = [resultSet intForColumn:@"visitingPenaltyScore"];
        model.week = (NSString *)[resultSet objectForColumnName:@"week"];
        model.status = [resultSet intForColumn:@"status"];
        model.hostLogo = (NSString *)[resultSet objectForColumnName:@"hostLogo"];
        model.hasIntelligence = [resultSet intForColumn:@"hasIntelligence"];
        model.hasShiPing = [resultSet intForColumn:@"hasshiping"];
        model.visitingLogo = (NSString *)[resultSet objectForColumnName:@"visitingLogo"];
        NSString *stage = (NSString *)[resultSet objectForColumnName:@"stage"];
        if (stage != nil && ![stage isKindOfClass:[NSNull class]]) {
            NSData *jsonData = [stage dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            model.stage = dic;
        }
        model.hasAttention = [resultSet intForColumn:@"hasAttention"];
    }
    return model;
}

- (NSMutableArray *)selectBiSaiModelWithTime:(int)time andMinStatus:(int)minStatus andMaxStatus:(int)maxStatus {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *selectTime = [NSDate dateWithTimeIntervalSince1970:time];// 选择的时间

    int last = 0, next = 0;
    if (maxStatus == 0) {
        // 赛程,赛果
        NSDateComponents *components1 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selectTime];
        NSDate *startDate = [calendar dateFromComponents:components1];
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        last = (int)[startDate  timeIntervalSince1970];
        next = (int)[endDate  timeIntervalSince1970];
    } else {
        // 全部,进行中
        // 判断当前时间是否是凌晨3点前
        NSDate *nowTime = [NSDate date];  // 当前时间
        NSDateComponents *components2 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nowTime];
        NSDate *startDate = [calendar dateFromComponents:components2];
        NSDate *comDate = [calendar dateByAddingUnit:NSCalendarUnitHour value:3 toDate:startDate options:0];
        NSComparisonResult result = [nowTime compare:comDate];
        NSDate *beginState = startDate;
        if (result == NSOrderedSame || result == NSOrderedAscending) {
            beginState = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:startDate options:0];
        }
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        last = (int)[startDate  timeIntervalSince1970];
        next = (int)[endDate  timeIntervalSince1970];
    }

    FMResultSet *resultSet;
    if (maxStatus == 0) {
        resultSet = [self.fmdb executeQuery:@"select * from tb_bisai where (biSaiTime >= ?) and (biSaiTime < ?) and status = ? order by biSaiTime ", @(last), @(next), @(minStatus)];
    } else {
        resultSet = [self.fmdb executeQuery:@"select * from tb_bisai where (biSaiTime >= ?) and (biSaiTime < ?) and status >= ? and status <= ? order by biSaiTime ", @(last), @(next), @(minStatus), @(maxStatus)];
    }
    NSMutableArray *array = [NSMutableArray array];
    while ([resultSet next]) {
        RBBiSaiModel *model = [[RBBiSaiModel alloc]init];
        model.namiId = [resultSet intForColumn:@"namiId"];
        model.index = [resultSet intForColumn:@"id"];
        model.matcheventId = [resultSet intForColumn:@"namiId"];
        model.hostID = [resultSet intForColumn:@"hostID"];
        model.visitingID = [resultSet intForColumn:@"visitingID"];
        model.hostTeamName = (NSString *)([resultSet objectForColumnName:@"hostTeamName"]);
        model.visitingTeamName = (NSString *)[resultSet objectForColumnName:@"visitingTeamName"];
        model.biSaiTime = [resultSet intForColumn:@"biSaiTime"];
        model.TeeTime = [resultSet intForColumn:@"TeeTime"];
        model.eventName = (NSString *)[resultSet objectForColumnName:@"eventName"];
        model.eventLongName = (NSString *)[resultSet objectForColumnName:@"eventLongName"];
        model.ballData = (NSString *)[resultSet objectForColumnName:@"ballData"];
        model.eventId = [resultSet intForColumn:@"eventId"];
        model.stageName = (NSString *)[resultSet objectForColumnName:@"stageName"];
        model.hostCorner = [resultSet intForColumn:@"hostCorner"];
        model.visitingCorner = [resultSet intForColumn:@"visitingCorner"];
        model.hostHalfScore = [resultSet intForColumn:@"hostHalfScore"];
        model.visitingHalfScore = [resultSet intForColumn:@"visitingHalfScore"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];
        model.visitingPointScore = [resultSet intForColumn:@"visitingPointScore"];
        model.hostScore = [resultSet intForColumn:@"hostScore"];
        model.visitingScore = [resultSet intForColumn:@"visitingScore"];
        model.hostRedCard = [resultSet intForColumn:@"hostRedCard"];
        model.visitingRedCard = [resultSet intForColumn:@"visitingRedCard"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];  model.hostYellowCard = [resultSet intForColumn:@"hostYellowCard"];
        model.visitingYellowCard = [resultSet intForColumn:@"visitingYellowCard"];
        model.hostOvertimeScore = [resultSet intForColumn:@"hostOvertimeScore"];
        model.visitingOvertimeScore = [resultSet intForColumn:@"visitingOvertimeScore"];
        model.hostPenaltyScore = [resultSet intForColumn:@"hostPenaltyScore"];
        model.visitingPenaltyScore = [resultSet intForColumn:@"visitingPenaltyScore"];
        model.week = (NSString *)[resultSet objectForColumnName:@"week"];
        model.status = [resultSet intForColumn:@"status"];
        model.hostLogo = (NSString *)[resultSet objectForColumnName:@"hostLogo"];
        model.hasIntelligence = [resultSet intForColumn:@"hasIntelligence"];
        model.hasShiPing = [resultSet intForColumn:@"hasshiping"];
        model.visitingLogo = (NSString *)[resultSet objectForColumnName:@"visitingLogo"];
        NSString *stage = (NSString *)[resultSet objectForColumnName:@"stage"];
        if (stage != nil && ![stage isKindOfClass:[NSNull class]]) {
            NSData *jsonData = [stage dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            model.stage = dic;
        }
        model.hasAttention = [resultSet intForColumn:@"hasAttention"];
        if (![model.visitingTeamName isKindOfClass:[NSNull class]] && ![model.hostTeamName isKindOfClass:[NSNull class]]) {
            [array addObject:model];
        }
    }
    return array;
}

- (NSMutableArray *)selectBiSaiModelWithStr:(NSString *)str {
    FMResultSet *resultSet = [self.fmdb executeQuery:[NSString stringWithFormat:@"select * from tb_bisai where  eventName like '%%%@%%'or  visitingTeamName like '%%%@%%' or  hostTeamName like '%%%@%%' order by status", str, str, str]];
    NSMutableArray *array = [NSMutableArray array];
    while ([resultSet next]) {
        RBBiSaiModel *model = [[RBBiSaiModel alloc]init];
        model.index = [resultSet intForColumn:@"id"];
        model.namiId = [resultSet intForColumn:@"namiId"];
        model.matcheventId = [resultSet intForColumn:@"namiId"];
        model.hostID = [resultSet intForColumn:@"hostID"];
        model.visitingID = [resultSet intForColumn:@"visitingID"];
        model.hostTeamName = (NSString *)([resultSet objectForColumnName:@"hostTeamName"]);
        model.visitingTeamName = (NSString *)[resultSet objectForColumnName:@"visitingTeamName"];
        model.ballData = (NSString *)[resultSet objectForColumnName:@"ballData"];
        model.biSaiTime = [resultSet intForColumn:@"biSaiTime"];
        model.TeeTime = [resultSet intForColumn:@"TeeTime"];
        model.eventName = (NSString *)[resultSet objectForColumnName:@"eventName"];
        model.eventLongName = (NSString *)[resultSet objectForColumnName:@"eventLongName"];
        model.eventId = [resultSet intForColumn:@"eventId"];
        model.stageName = (NSString *)[resultSet objectForColumnName:@"stageName"];
        model.hostCorner = [resultSet intForColumn:@"hostCorner"];
        model.hostHalfScore = [resultSet intForColumn:@"hostHalfScore"];
        model.visitingHalfScore = [resultSet intForColumn:@"visitingHalfScore"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];
        model.visitingPointScore = [resultSet intForColumn:@"visitingPointScore"];
        model.hostScore = [resultSet intForColumn:@"hostScore"];
        model.visitingScore = [resultSet intForColumn:@"visitingScore"];
        model.hostRedCard = [resultSet intForColumn:@"hostRedCard"];
        model.visitingRedCard = [resultSet intForColumn:@"visitingRedCard"];
        model.hostPointScore = [resultSet intForColumn:@"hostPointScore"];  model.hostYellowCard = [resultSet intForColumn:@"hostYellowCard"];
        model.visitingYellowCard = [resultSet intForColumn:@"visitingYellowCard"];
        model.hostOvertimeScore = [resultSet intForColumn:@"hostOvertimeScore"];
        model.visitingOvertimeScore = [resultSet intForColumn:@"visitingOvertimeScore"];
        model.hostPenaltyScore = [resultSet intForColumn:@"hostPenaltyScore"];
        model.visitingPenaltyScore = [resultSet intForColumn:@"visitingPenaltyScore"];
        model.week = (NSString *)[resultSet objectForColumnName:@"week"];
        model.status = [resultSet intForColumn:@"status"];
        model.hostLogo = (NSString *)[resultSet objectForColumnName:@"hostLogo"];
        model.hasIntelligence = [resultSet intForColumn:@"hasIntelligence"];
        model.visitingLogo = (NSString *)[resultSet objectForColumnName:@"visitingLogo"];
        model.hasShiPing = [resultSet intForColumn:@"hasshiping"];
        NSString *stage = (NSString *)[resultSet objectForColumnName:@"stage"];
        if (stage != nil && ![stage isKindOfClass:[NSNull class]]) {
            NSData *jsonData = [stage dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            model.stage = dic;
        }
        model.hasAttention = [resultSet intForColumn:@"hasAttention"];
        [array addObject:model];
    }

    return array;
}

@end
