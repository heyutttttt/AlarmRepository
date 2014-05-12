//
//  CurrentTime.m
//  WaverAlarm
//
//  Created by ryan on 14-4-23.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "CurrentTime.h"

@implementation CurrentTime

+ (instancetype)shareInstance
{
    static CurrentTime *_instance;
    
    static dispatch_once_t oncetoken;
    
    dispatch_once(&oncetoken, ^{
       
        _instance = [[CurrentTime alloc] initByCurrentTime];
        
        [_instance initTimer];
        
    });
    
    return _instance;
}

- (CurrentTime *)initByCurrentTime
{
    self = [super init];
    if (self)
    {
        [self updateTime];
    }
    return self;
}

- (void)initTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}


- (void)dealloc
{
    [timer invalidate];
}

- (void)updateTime
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSYearCalendarUnit|NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    self.currentSeconds = [dateComponents second];
    self.currentMins = [dateComponents minute];
    self.currentHours = [dateComponents hour];
    self.currentYears = [dateComponents year];
    self.currentMonths = [dateComponents month];
    self.currentDays = [dateComponents day];
    self.currentWeeks = [dateComponents weekday];
}



@end
