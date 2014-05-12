//
//  AlarmCell.m
//  WaverAlarm
//
//  Created by ryan on 14-5-4.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "AlarmCell.h"
#import "User.h"


@implementation AlarmCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image = [UIImage imageNamed:@"SettingAlarm"];
        [self setFrame:CGRectMake(self.left, self.top, image.size.width, image.size.height)];
        bgView = [[UIImageView alloc] initWithImage:image];
        [bgView setFrame:self.bounds];
        
        [self addSubview:bgView];
        [self createTimeLabel];
        
//        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOfTapRecognizer:)];
//        [tapRecognizer setNumberOfTouchesRequired:1];
//        [tapRecognizer setNumberOfTapsRequired:1];
//        [self addGestureRecognizer:tapRecognizer];
//        
//        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleOfLongRecognizer:)];
//        [longRecognizer setMinimumPressDuration:1.0];
//        [self addGestureRecognizer:longRecognizer];
    }
    return self;
}

- (void)createTimeLabel
{
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.width - 10, 30)];
    [timeLabel setCenter:CGPointMake(bgView.width/2.0,bgView.height/2.0)];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setFont:[UIFont fontWithName:@"Heiti TC" size:17]];
    [self addSubview:timeLabel];
}

- (void)setAlarm:(Alarm *)newAlarm
{
    alarm = newAlarm;
    
    if (!alarm.shouldSound)
    {
        isCancel = YES;
        [self setOffViewHidden:NO];
    }
    
    else
    {
        isCancel = NO;
        [self setOffViewHidden:YES];
    }
}

- (void)setOffViewHidden:(BOOL)shouldHide
{
    if (!offView && !shouldHide)
    {
        offView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"offView"]];
        [offView setFrame:CGRectMake(0, 0, offView.width, offView.height)];
        [offView setAlpha:0.3];
        [self addSubview:offView];
    }
    
    else if (offView)
    {
        [offView setHidden:shouldHide];
    }
}

- (void)updateTimeLabel
{
    if (!timeLabel)
    {
        [self createTimeLabel];
    }
    
    NSString *minString;
    if (alarm.alarmMin < 10)
    {
        minString = [NSString stringWithFormat:@"0%d",alarm.alarmMin];
    }
    
    else
    {
        minString = [NSString stringWithFormat:@"%d",alarm.alarmMin];
    }
    
    [timeLabel setText:[NSString stringWithFormat:@"%d:%@",alarm.alarmHour,minString]];
}

//- (void)startWobble
//{
//    srand([[NSDate date] timeIntervalSince1970]);
//    float rand=(float)random();
//    
//    CFTimeInterval delay=rand*0.0000000001;
//    
//    [UIView animateWithDuration:0.1 delay:delay options:0  animations:^{
// 
//        self.transform=CGAffineTransformMakeRotation(-0.05);
//    } completion:^(BOOL finished){
//        
//         [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^  {
//             
//              self.transform=CGAffineTransformMakeRotation(0.05);
//             
//          } completion:^(BOOL finished) {}];
//     }];
//}
//
//- (void)stopWobble
//{
//    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
//     {
//         self.transform=CGAffineTransformIdentity;
//     } completion:^(BOOL finished) {
//         
//         [deleteView setHidden:YES];
//     }];
//}
//
//- (void)scaleAnimation
//{
//    CGAffineTransform transfom = CGAffineTransformMakeScale(1.1, 1.1);
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        
//            self.transform = transfom;
//        
//    } completion:^(BOOL finished) {
//       
//        [self restoreAnimation];
//        [self startWobble];
//        
//    }];
//}
//
//- (void)restoreAnimation
//{
//    [UIView animateWithDuration:0.1 animations:^{
//        
//        self.transform = CGAffineTransformIdentity;
//        
//    } completion:^(BOOL finished) {
//        
//        if (!deleteView)
//        {
//            deleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DeleteView"]];
//            [deleteView setCenter:CGPointMake(self.centerX, self.centerY + 10)];
//            
//            [self addSubview:deleteView];
//        }
//        
//        else if (deleteView.hidden)
//        {
//            [deleteView setHidden:NO];
//        }
//    }];
//}

@end
