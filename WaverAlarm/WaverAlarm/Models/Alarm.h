//
//  Alarm.h
//  WaverAlarm
//
//  Created by ryan on 14-5-2.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger alarmHour;
@property (nonatomic, assign) NSInteger alarmMin;
@property (nonatomic, strong) NSString *alarmMusicName;
@property (nonatomic, strong) NSArray *alarmDays;
@property (nonatomic, strong) NSString *alarmID;
@property (nonatomic, assign) BOOL shouldSound;
@property (nonatomic, strong) UILocalNotification *localNotification;

+ (Alarm *)createWithDic:(NSDictionary *)dic;
- (void)startLocalNotification;
- (void)stopLocalNofication;

@end
