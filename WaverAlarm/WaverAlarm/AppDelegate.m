//
//  AppDelegate.m
//  WaverAlarm
//
//  Created by ryan on 14-4-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"

#import "ShakeViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SwitchToMainVC object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainVC) name:SwitchToMainVC object:nil];
    
    application.applicationIconBadgeNumber  = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification)
    {
        NSLog(@"notification");
        currentAlarmID = [notification.userInfo objectForKey:ALARMID];
        
        [self playSong];
        
        ShakeViewController *shakeVC = [[ShakeViewController alloc] initWithNibName:@"ShakeViewController" bundle:nil];
        
        self.window.rootViewController = shakeVC;
    }
    
    else
    {
        mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        self.window.rootViewController = mainVC;
        
    }
    
    return YES;
}

- (void)showShakeVC
{
    if (isAnotherAlarm)
    {
        [self playSong];
        
        [self showAlertView];
    }
}

- (void)showAlertView
{
    alarmAlert = [[UIAlertView alloc] initWithTitle:nil message:@"不小睡就要开始摇了" delegate:self cancelButtonTitle:@"小睡" otherButtonTitles:@"取消", nil];
    [alarmAlert show];
}

- (void)showMainVC
{
    [audioPlayer stop];
    [[User shareInstance] cancelAlarmByID:currentAlarmID];
    
    if (!mainVC)
    {
        mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    }
    self.window.rootViewController = mainVC;
    
    [mainVC reloadCollectionViewData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        ShakeViewController *shakeVC = [[ShakeViewController alloc] initWithNibName:@"ShakeViewController" bundle:nil];
        
        self.window.rootViewController = shakeVC;
    }
    
    else if(buttonIndex == alertView.cancelButtonIndex)
    {
        //xiaoshui
        [audioPlayer stop];
        [[User shareInstance] setAdAlarmByID:currentAlarmID WithNap:YES];
        currentAlarmID = nil;
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    application.applicationIconBadgeNumber -= 1;
    
    if (![currentAlarmID isEqualToString:[notification.userInfo objectForKey:ALARMID]])
    {
        currentAlarmID = [notification.userInfo objectForKey:ALARMID];
        isAnotherAlarm = YES;
    }
    
    else
    {
        isAnotherAlarm = NO;
    }
    
    [self showShakeVC];
}

- (void)playSong
{
    NSString *music = [[User shareInstance] getAlarmByID:currentAlarmID].alarmMusicName;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:music ofType:@"caf"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [audioPlayer setNumberOfLoops:-1];
    [audioPlayer play];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
//    NSLog(@"applicationWillResignActive");
        application.applicationIconBadgeNumber  = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//        NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//            NSLog(@"applicationWillEnterForeground");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SetTimeLabel object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        NSLog(@"applicationDidBecomeActive");

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
