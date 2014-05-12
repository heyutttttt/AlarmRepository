//
//  User.h
//  WaverAlarm
//
//  Created by ryan on 14-5-2.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

@interface User : NSObject
{
    NSMutableArray *allAlarms;
}


+ (instancetype)shareInstance;
- (void)addAlarm:(Alarm *)alarm;
- (void)modifyAlarm:(Alarm *)newAlarm;

- (BOOL)isAlarmExist:(NSString *)ID;
- (NSMutableArray *)getAllAlarms;
- (Alarm *)getAlarmByID:(NSString *)ID;


- (BOOL)isAlarmsEmpty;
- (BOOL)isNoAlarmShouldSound;

- (void)removeAlarmByID:(NSString *)ID;
- (void)cancelAlarmByID:(NSString *)ID;
- (void)startAlarmByID:(NSString *)ID;
- (void)setAdAlarmByID:(NSString *)ID WithNap:(BOOL)isNap;

@end
