//
//  ShakeViewController.m
//  WaverAlarm
//
//  Created by ryan on 14-5-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "ShakeViewController.h"

@interface ShakeViewController ()

@end

@implementation ShakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self stopUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    motionManager = [[CMMotionManager alloc] init];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    
    [self startUpdates];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)startUpdates
{
    if ([motionManager isAccelerometerAvailable] == YES)
    {
        [motionManager setAccelerometerUpdateInterval:0.01];
        
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
        {
            
            if ((fabs(accelerometerData.acceleration.x) > 2.0 || fabs(accelerometerData.acceleration.y) > 2.0 || fabs(accelerometerData.acceleration.z) > 2.0) && percentage < 100)
            {
                percentage++;
                
                NSDate *currentDate = [NSDate date];
                if (!shakeDate)
                {
                    shakeDate = [currentDate dateByAddingTimeInterval:2.0f];
                }
                
                count++;
                
                if (([currentDate  compare:shakeDate] == NSOrderedDescending))
                {
                    if (count >= 4)
                    {
                        percentage += 2;
                    }
                    shakeDate = nil;
                    count = 0;
                }
                
                if (percentage >= 100)
                {
                    [bgView setTop:0];
                    [countLabel setText:@"100%%"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:SwitchToMainVC object:nil];
                }
                
                else
                {
                    NSLog(@"%d",percentage);
                    [countLabel setText:[NSString stringWithFormat:@"%d%%",percentage]];
                    [bgView setTop:(400 - percentage*4)];
                }
                
            }
            
            else
            {
                count = 0;
                shakeDate = nil;
            }
            
        }];
    }
    
}

- (void)stopUpdates
{
    
    if ([motionManager isAccelerometerActive] == YES) {
        [motionManager stopAccelerometerUpdates];
    }
}

@end
