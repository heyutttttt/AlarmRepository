//
//  User.m
//  WaverAlarm
//
//  Created by ryan on 14-5-2.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "User.h"
#import "CurrentTime.h"

#define ALARMDATA @"ALARMDATA"

@implementation User

+ (instancetype)shareInstance
{
    static User *_instance ;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        _instance = [[User alloc] init];
    });
    
//    [_instance clearData];
    
    return _instance;
}

- (void)loadData
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ALARMDATA];
    allAlarms = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)saveData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allAlarms];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:ALARMDATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearData
{
    for (Alarm *alarm in allAlarms)
    {
        for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if ([[notification.userInfo objectForKey:ALARMID] isEqualToString:alarm.alarmID])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
    
    [allAlarms removeAllObjects];
    [self saveData];
}

- (void)resetAlarmNotifications
{
    [self loadData];
    
    for (Alarm *alarm in allAlarms)
    {
        NSNumber *day = alarm.alarmDays[CURRENTTIME.currentWeeks-1];
        if (alarm.shouldSound && [day isEqualToNumber:@1])
        {
            if (![self isLocalNotificationExist:alarm])
            {
                [alarm startLocalNotification];
            }
        }
        
        else
        {
            [alarm stopLocalNofication];
        }
    }
}

- (void)addAlarm:(Alarm *)alarm
{
 
    [self loadData];
    if (!allAlarms)
    {
        allAlarms = [[NSMutableArray alloc] init];
    }
    
    [allAlarms addObject:alarm];
    [self saveData];
}

//- (void)removeAlarm:(Alarm *)alarm
//{
//    [alarm stopLocalNofication];
//    [self loadData];
//    [allAlarms removeObject:alarm];
//    [self saveData];
//}

- (void)removeAlarmByID:(NSString *)ID
{
    [self loadData];
    
    for (Alarm *alarm in allAlarms)
    {
        if ([alarm.alarmID isEqualToString:ID])
        {
            [alarm stopLocalNofication];
            [allAlarms removeObject:alarm];
            [self saveData];
            break;
        }
    }
}


- (BOOL)isAlarmExist:(NSString *)ID
{
    //consider allalarms is null
    for (Alarm *alarm in allAlarms)
    {
        if ([alarm.alarmID isEqualToString:ID])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isLocalNotificationExist:(Alarm *)alarm
{
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if ([[notification.userInfo objectForKey:ALARMID] isEqualToString:alarm.alarmID])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isEmpty
{
    [self loadData];
    if (allAlarms.count != 0)
    {
        for (Alarm *alarm in allAlarms)
        {
            if (alarm.shouldSound)
            {
                return NO;
            }
        }
        return YES;
    }
    
    return YES;
}

//- (Alarm *)getAlarm:(NSString *)ID
//{
//    for (Alarm *alarm in allAlarms)
//    {
//        if ([alarm.alarmID isEqualToString:ID])
//        {
//            return alarm;
//        }
//    }
//    
//    return nil;
//}

- (NSMutableArray *)getAllAlarms
{
    // 会被修改吗
    [self loadData];
    return allAlarms;
}

- (void)descri
{
    [self loadData];
    NSLog(@"....");
    for (Alarm *alarm in allAlarms)
    {
        NSLog(@"%d:%d,%@",alarm.alarmHour,alarm.alarmMin,alarm.alarmID);
    }
}
@end

