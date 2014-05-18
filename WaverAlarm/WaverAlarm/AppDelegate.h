//
//  AppDelegate.h
//  WaverAlarm
//
//  Created by ryan on 14-4-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    NSString *currentAlarmID;
    MainViewController *mainVC;
    AVAudioPlayer *audioPlayer;
    UIAlertView *alarmAlert;
    
    BOOL isAnotherAlarm;
}
@property (strong, nonatomic) UIWindow *window;

@end
