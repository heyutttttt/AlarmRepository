//
//  CurrentTime.h
//  WaverAlarm
//
//  Created by ryan on 14-4-23.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentTime : NSObject
{
    NSTimer *timer;
}

@property (nonatomic, assign) NSInteger currentMins;
@property (nonatomic, assign) NSInteger currentHours;
@property (nonatomic, assign) NSInteger currentSeconds;
@property (nonatomic, assign) NSInteger currentYears;
@property (nonatomic, assign) NSInteger currentMonths;
@property (nonatomic, assign) NSInteger currentDays;
@property (nonatomic, assign) NSInteger currentWeeks;

+ (instancetype)shareInstance;

@end
