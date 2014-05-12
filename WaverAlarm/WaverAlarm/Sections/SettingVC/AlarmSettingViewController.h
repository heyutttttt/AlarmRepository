//
//  AlarmSettingViewController.h
//  WaverAlarm
//
//  Created by ryan on 14-4-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentTime.h"
#import "Button.h"
#import "Alarm.h"
#import "SelectMusicViewController.h"



@interface AlarmSettingViewController : UIViewController
{
    IBOutlet UIImageView *background;
    IBOutlet UIImageView *background4s;
    IBOutlet UIImageView *minDotsView4s;
    IBOutlet UIImageView *minDotsView;
    
    IBOutlet UIImageView *sunLightsView;
    
    IBOutlet Button *sunButton;
    IBOutlet Button *monButton;
    IBOutlet Button *tueButton;
    IBOutlet Button *wedButton;
    IBOutlet Button *thuButton;
    IBOutlet Button *friButton;
    IBOutlet Button *satButton;
    
    IBOutlet UIButton *hourButton;
    IBOutlet UIButton *minButton;
    
    IBOutlet UIButton *stopButton;
    IBOutlet UIButton *deleteButton;
    
    
    UIImageView *selectedButtonView;
    
    IBOutlet UILabel *musicLabel;
    IBOutlet UIButton *musicButton;
    
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *fixButton;
    
    IBOutlet UILabel *settingTimeLable;
    
    CurrentTime *currentTime;
    
    UIImageView *dotView;
    
    BOOL shouldReset;
    BOOL isPerHour;
    
    BOOL shouldBegin;
    BOOL shouldEnd;
    BOOL isAnimating;
    
    BOOL isMoved;
    
    NSInteger settingHours;
    NSInteger settingMins;
    NSMutableArray *settingDays;
    
    NSInteger totalAngles;
    NSInteger lastTotalAngles;
    
    CGPoint prePosition;
    CGPoint newPosition;
    
    NSInteger hoursCount;

    SelectMusicViewController *selectMusicVC;
}

@property (nonatomic, assign) BOOL isResetAlarm;
@property (nonatomic, strong) Alarm *alarm;

@end
