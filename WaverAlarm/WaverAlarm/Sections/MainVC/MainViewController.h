//
//  MainViewController.h
//  WaverAlarm
//
//  Created by ryan on 14-4-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentTime.h"

@interface MainViewController : UIViewController
{
    IBOutlet UIButton *addButton;
    
    IBOutlet UIButton *hourButton;
    IBOutlet UIButton *minButton;
    
    IBOutlet UIImageView *sunLightsView;
    
    IBOutlet UIImageView *background;
    
    IBOutlet UIImageView *background4s;
    
    float angle;
    CurrentTime *currentTime;
    
    IBOutlet UIImageView *alarmTapView;
}

- (void)reloadCollectionViewData;

@end
