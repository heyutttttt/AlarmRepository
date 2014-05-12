//
//  Alarm.m
//  WaverAlarm
//
//  Created by ryan on 14-5-2.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Alarm.h"
#import "User.h"

#define OneDaySecondes 60*60*24

@implementation Alarm


+ (Alarm *)createWithDic:(NSDictionary *)dic
{
    User *user = [User shareInstance];
    NSInteger hour = [[dic objectForKey:ALARMHOUR] integerValue];
    NSInteger min = [[dic objectForKey:ALARMMIN] integerValue];
    NSString *ID = [NSString stringWithFormat:@"%d%d",hour,min];
    
    Alarm *alarm = nil;
    
    if (![user isAlarmExist:ID])
    {
        alarm = [[Alarm alloc] init];
        alarm.alarmHour = hour;
        alarm.alarmMin = min;
        alarm.alarmDays = [dic objectForKey:ALARMDAYS];
        alarm.alarmMusicName = [dic objectForKey:ALARMMUSIC];
        
        alarm.alarmID = ID;
        alarm.shouldSound = YES;
    }

    return alarm;
}

- (void)setAdditionalAlarmWithNap:(BOOL)isNap
{
    [self cancelLocalNofications];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:((isNap) ? (8*60) : (15*60))];
    [self.localNotifications addObject:[self createLocalNotificationWithDate:date WithRepeate:NO]];
}

- (void)createLocalNotification
{
    if (!self.localNotifications)
    {
        self.localNotifications = [NSMutableArray array];
    }
    
    else
    {
        [self cancelLocalNofications];
        [self.localNotifications removeAllObjects];
    }
    
    CurrentTime *currentTime = [CurrentTime shareInstance];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *alarmDate = [dateFormatter dateFromString:
                         [NSString stringWithFormat:@"%d-%d-%d %d:%d",currentTime.currentYears,currentTime.currentMonths,currentTime.currentDays,self.alarmHour,self.alarmMin]];
    
    if ([self shouldRepeatSound])
    {
        for (int i=0; i<[self.alarmDays count]; i++)
        {
            NSNumber *day = [self.alarmDays objectAtIndex:i];
            if ( [day isEqualToNumber:@1])
            {
                if (i < currentTime.currentWeeks -1)
                {
                    NSInteger count  = 7 - (currentTime.currentWeeks -1 - i);
                    alarmDate = [alarmDate dateByAddingTimeInterval:OneDaySecondes*count];
                    
                }
                
                else if (i == currentTime.currentWeeks -1)
                {
                    if (self.alarmHour < currentTime.currentHours ||
                       (self.alarmHour == currentTime.currentHours && self.alarmMin <= currentTime.currentMins))
                    {
                        alarmDate = [alarmDate dateByAddingTimeInterval:OneDaySecondes];
                    }
                }
                
                else
                {
                    NSInteger count = i - (currentTime.currentWeeks - 1);
                    alarmDate = [alarmDate dateByAddingTimeInterval:count*OneDaySecondes];
                }
                
                [self.localNotifications addObject:[self createLocalNotificationWithDate:alarmDate WithRepeate:YES]];
                
                [self.localNotifications addObject:[self createRepeateLocalNotificationWithDate:[alarmDate dateByAddingTimeInterval:30] WithRepeate:YES]];
            }
        }
    }
    
    else
    {
        if (self.alarmHour < currentTime.currentHours || (self.alarmHour == currentTime.currentHours && self.alarmMin <= currentTime.currentMins))
        {
            alarmDate = [alarmDate dateByAddingTimeInterval:60*60*24];
        }
        
        [self.localNotifications addObject:[self createLocalNotificationWithDate:alarmDate WithRepeate:NO]];
        
        [self.localNotifications addObject:[self createRepeateLocalNotificationWithDate:[alarmDate dateByAddingTimeInterval:30] WithRepeate:NO]];

    }
    
}

- (void)cancelLocalNofications
{
    if (!self.localNotifications)
    {
        for (UILocalNotification *notification in self.localNotifications)
        {
            if (!notification)
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

- (UILocalNotification *)createLocalNotificationWithDate:(NSDate *)alarmDate WithRepeate:(BOOL)shouldRepeat
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone=[NSTimeZone defaultTimeZone];
    localNotification.fireDate = alarmDate;
    
    localNotification.repeatInterval =
    ((shouldRepeat) ? kCFCalendarUnitWeekday : 0); //循环次数，kCFCalendarUnitWeekday一周一次
    
    localNotification.alertBody=@"我响了,摇我拉！";
    
    [localNotification setSoundName:[self.alarmMusicName stringByAppendingString:@".caf"]];

    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:[alarmDate description],@"date", self.alarmID,ALARMID,nil];
    localNotification.userInfo = infoDic;
    
    localNotification.applicationIconBadgeNumber += 1; //设置app图标右上角的数字
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    return localNotification;
}

- (UILocalNotification *)createRepeateLocalNotificationWithDate:(NSDate *)alarmDate WithRepeate:(BOOL)shouldRepeat
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone=[NSTimeZone defaultTimeZone];
    localNotification.fireDate = alarmDate;
    
    localNotification.repeatInterval =
    ((shouldRepeat) ? kCFCalendarUnitWeekday : 0); //循环次数，kCFCalendarUnitWeekday一周一次
    
    [localNotification setSoundName:[self.alarmMusicName stringByAppendingString:@".caf"]];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:[alarmDate description],@"date", self.alarmID,ALARMID,nil];
    localNotification.userInfo = infoDic;
   
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    return localNotification;
}

- (BOOL)shouldRepeatSound
{
    for (NSNumber *number in self.alarmDays)
    {
        if ([number isEqualToNumber:@1])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma NSCoding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSNumber numberWithInteger:self.alarmHour] forKey:@"alarmHour"];
    [coder encodeObject:[NSNumber numberWithInteger:self.alarmMin] forKey:@"alarmMin"];
    [coder encodeObject:self.alarmID forKey:@"alarmID"];
    [coder encodeObject:self.alarmMusicName forKey:@"alarmMusicName"];
    [coder encodeObject:self.alarmDays forKey:@"alarmDays"];
    [coder encodeObject:[NSNumber numberWithBool:self.shouldSound] forKey:@"shouldSound"];
    
    [coder encodeObject:self.localNotifications forKey:@"localNotifications"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.alarmHour = [[coder decodeObjectForKey:@"alarmHour"] integerValue];
        self.alarmMin = [[coder decodeObjectForKey:@"alarmMin"] integerValue];
        self.shouldSound = [[coder decodeObjectForKey:@"shouldSound"] boolValue];
        
        self.alarmID = [coder decodeObjectForKey:@"alarmID"];
        self.alarmDays = [coder decodeObjectForKey:@"alarmDays"];
        self.alarmMusicName = [coder decodeObjectForKey:@"alarmMusicName"];
        self.localNotifications = [coder decodeObjectForKey:@"localNotifications"];
    }
    return self;
}

@end
