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
- (void)resetAlarmNotifications;

- (BOOL)isAlarmExist:(NSString *)ID;
//- (NSMutableArray *)getAllAlarms;
- (void)descri;
- (BOOL)isEmpty;

- (void)removeAlarmByID:(NSString *)ID;

@end
