//
//  Alarm.m
//  WaverAlarm
//
//  Created by ryan on 14-5-2.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Alarm.h"
#import "User.h"

@implementation Alarm


+ (Alarm *)createWithDic:(NSDictionary *)dic
{
    User *user = [User shareInstance];
    NSInteger hour = [[dic objectForKey:ALARMHOUR] integerValue];
    NSInteger min = [[dic objectForKey:ALARMMIN] integerValue];
    NSString *ID = [NSString stringWithFormat:@"%d%d",hour,min];
    
    Alarm *alarm = NULL;
    
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

- (void)startLocalNotification
{
    
    if (!self.localNotification)
    {
        self.localNotification = [[UILocalNotification alloc] init];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate *alarmDate = [dateFormatter dateFromString:
                         [NSString stringWithFormat:@"%d-%d-%d %d:%d",CURRENTTIME.currentYears,CURRENTTIME.currentMonths,CURRENTTIME.currentDays,self.alarmHour,self.alarmMin]];
//    NSLog(@"%@",alarmDate);
    self.localNotification.timeZone=[NSTimeZone defaultTimeZone];
    self.localNotification.fireDate = alarmDate;
    
//    self.localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];

    self.localNotification.repeatInterval = 0; //循环次数，kCFCalendarUnitWeekday一周一次


    self.localNotification.soundName = UILocalNotificationDefaultSoundName;

    self.localNotification.alertBody=@"我响了,摇我吧！";

//    self.localNotification.alertAction = @"打开";  //提示框按钮
//    self.localNotification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失

    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        self.localNotification.applicationIconBadgeNumber += 1; //设置app图标右上角的数字
    }

    //下面设置本地通知发送的消息，这个消息可以接受
    NSDictionary* infoDic = [NSDictionary dictionaryWithObject:self.alarmID forKey:ALARMID];
    self.localNotification.userInfo = infoDic;

    //发送通知

    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];

}

- (void)stopLocalNofication
{
    if (self.localNotification)
    {
//        for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
//        {
//            if ([[notification.userInfo objectForKey:ALARMID] isEqualToString:self.alarmID])
//            {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//            }
//        }
        [[UIApplication sharedApplication] cancelLocalNotification:self.localNotification];
    }
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
    
    [coder encodeObject:self.localNotification forKey:@"localNotification"];
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
        self.localNotification = [coder decodeObjectForKey:@"localNotification"];
    }
    return self;
}

@end
