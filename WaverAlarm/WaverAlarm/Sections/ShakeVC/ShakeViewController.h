//
//  ShakeViewController.h
//  WaverAlarm
//
//  Created by ryan on 14-5-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface ShakeViewController : UIViewController
{
    IBOutlet UILabel *countLabel;
    IBOutlet UIImageView *bgView;
    CMMotionManager *motionManager;
    
    NSInteger percentage;
    NSInteger count;//in 2s 
    
    NSDate *shakeDate;
    
    BOOL isAnimating;
    
}
@end
