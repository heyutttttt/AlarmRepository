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
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
  
    return _instance;
}

- (void)loadData
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ALARMDATA];
    if (data)
    {
        allAlarms = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
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

- (void)setAdAlarmByID:(NSString *)ID WithNap:(BOOL)isNap
{
    [self loadData];
    
    if (![self isAlarmsEmpty])
    {
        for (Alarm *alarm in allAlarms)
        {
            if ([alarm.alarmID isEqualToString:ID])
            {
                [alarm setAdditionalAlarmWithNap:isNap];
            }
        }
        
        [self saveData];
    }
    
}

- (void)resetAlarmNotifications
{
    [self loadData];
    
    for (Alarm *alarm in allAlarms)
    {
        if (alarm.shouldSound)
        {
            if ([alarm shouldRepeatSound])
            {
                [alarm cancelLocalNofications];
            }
            
            [alarm createLocalNotification];
        }
        
        else
        {
            [alarm cancelLocalNofications];
        }
    }
    
    [self saveData];
}

- (void)modifyAlarm:(Alarm *)newAlarm
{
    [self loadData];
    
    for (Alarm *alarm in allAlarms)
    {
        if ([alarm.alarmID isEqualToString:newAlarm.alarmID])
        {
            NSString *ID = [NSString stringWithFormat:@"%d%d",newAlarm.alarmHour,newAlarm.alarmMin];
            
            alarm.alarmID = ID;
            
            alarm.alarmHour = newAlarm.alarmHour;
            alarm.alarmMin = newAlarm.alarmMin;
            alarm.alarmMusicName = newAlarm.alarmMusicName;
            alarm.alarmDays = newAlarm.alarmDays;
            alarm.shouldSound = newAlarm.shouldSound;
            
            [self saveData];
            [self resetAlarmNotifications];
            break;
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
    
    [self resetAlarmNotifications];
}

- (void)removeAlarmByID:(NSString *)ID
{
    if (![self isAlarmsEmpty])
    {
        [self loadData];
        
        for (Alarm *alarm in allAlarms)
        {
            if ([alarm.alarmID isEqualToString:ID])
            {
                [alarm cancelLocalNofications];
                [allAlarms removeObject:alarm];
                
                [self saveData];
                
                [self resetAlarmNotifications];
                break;
            }
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

- (BOOL)isAlarmsEmpty
{
    [self loadData];
    
    if (allAlarms.count != 0)
    {
        return NO;
    }
    
   return YES;
}

- (BOOL)isNoAlarmShouldSound
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
        
    }
    
    return YES;
}


- (void)cancelAlarmByID:(NSString *)ID
{
    if (![self isAlarmsEmpty])
    {
        [self loadData];
        
        for (Alarm *alarm in allAlarms)
        {
            if ([alarm.alarmID isEqualToString:ID])
            {
                
                if (![alarm shouldRepeatSound])
                {
                    alarm.shouldSound = NO;
                }

                [self saveData];
                [self resetAlarmNotifications];
                
                break;
            }
        }
        
    }
}

- (void)startAlarmByID:(NSString *)ID
{
    if (![self isAlarmsEmpty])
    {
        [self loadData];
        
        for (Alarm *alarm in allAlarms)
        {
            if ([alarm.alarmID isEqualToString:ID])
            {
                alarm.shouldSound = YES;
                [self saveData];
                [self resetAlarmNotifications];
                
                break;
            }
        }
        
    }
}

- (Alarm *)getAlarmByID:(NSString *)ID
{
    [self loadData];
    for (Alarm *alarm in allAlarms)
    {
        if ([alarm.alarmID isEqualToString:ID])
        {
            return alarm;
        }
    }
    
    return nil;
}

- (NSMutableArray *)getAllAlarms
{
    // 会被修改吗
    [self loadData];
    return allAlarms;
}

@end

