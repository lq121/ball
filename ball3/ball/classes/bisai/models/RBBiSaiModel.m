#import "RBBiSaiModel.h"

@implementation RBBiSaiModel
+ (instancetype)getBiSaiModelWithArray:(NSArray *)arr andTeams:(NSDictionary *)teams andEvents:(NSDictionary *)events andStages:(NSDictionary *)stages {
    int time = [arr[3]intValue];
    RBBiSaiModel *model = [[self alloc]init];
    model.namiId = [arr[0]intValue];
    model.matcheventId = [arr[1]intValue];
    NSArray *arr1 = arr[5];
    NSArray *arr2 = arr[6];
    NSString *team1key = [NSString stringWithFormat:@"%d", [arr1[0]intValue]];
    NSString *team2key = [NSString stringWithFormat:@"%d", [arr2[0]intValue]];
    model.hostID = [teams[team1key][@"id"] intValue];
    model.visitingID = [teams[team2key][@"id"]intValue];
    model.hostTeamName = teams[team1key][@"name_zh"];
    model.visitingTeamName = teams[team2key][@"name_zh"];
    model.hostLogo = teams[team1key][@"logo"];
    model.visitingLogo = teams[team2key][@"logo"];
    model.status = [arr[2]intValue];
    model.biSaiTime = time;
    NSString *Key = [NSString stringWithFormat:@"%d", [arr[1]intValue]];
    model.eventName = events[Key][@"short_name_zh"];
    model.eventLongName = events[Key][@"name_zh"];
    model.eventId = [arr[1]intValue];
    model.stageName = stages[Key][@"name_zh"];
    model.hostScore = [arr1[2]intValue];
    model.visitingScore = [arr2[2]intValue];
    model.hostHalfScore = [arr1[3]intValue];
    model.visitingHalfScore = [arr2[3]intValue];
    model.hostCorner = [arr1[6]intValue];
    model.visitingCorner = [arr2[6]intValue];
    model.hostPointScore = [arr1[8]intValue];
    model.visitingPointScore = [arr2[8]intValue];
    model.hostRedCard = [arr1[4]intValue];
    model.visitingRedCard = [arr2[4]intValue];
    model.hostYellowCard = [arr1[5]intValue];
    model.visitingYellowCard = [arr2[5]intValue];
    model.hostOvertimeScore = [arr1[7]intValue];
    model.visitingOvertimeScore = [arr2[7]intValue];
    model.hostPenaltyScore = [arr1[8]intValue];
    model.visitingPenaltyScore = [arr2[8]intValue];
    model.week = [NSString weekdayStringFromDate:time];
    model.hasIntelligence = [arr[8][3] boolValue];
    int stageId = [arr[9][0] intValue];
    model.stage = stages[[NSString stringWithFormat:@"%d", stageId] ];
    model.TeeTime = [arr[4]intValue];
    if (model.status == 2) {
        model.TeeTimeStr = [NSString stringWithFormat:@"%@", [NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:[arr[4]intValue]]];
    } else if (model.status == 3) {
        model.TeeTimeStr = @"中";
    } else if (model.status >= 4 && model.status <= 7) {
        long timeCount =  (long)[[NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:[arr[4]intValue]] longLongValue];
        if (timeCount + 45 > 90) {
            model.TeeTimeStr = xiabanchangjia;
        } else {
            model.TeeTimeStr = [NSString stringWithFormat:@"%ld", timeCount + 45];
        }
    } else if (model.status  == 8) {
        model.TeeTimeStr = wan;
    } else if (model.status == 1) {
        model.TeeTimeStr = wei;
    } else if (model.status > 8 || model.status == 0) {
        model.TeeTimeStr = yanci;
    }
    return model;
}

@end
