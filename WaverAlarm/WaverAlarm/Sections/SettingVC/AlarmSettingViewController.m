//
//  AlarmSettingViewController.m
//  WaverAlarm
//
//  Created by ryan on 14-4-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "AlarmSettingViewController.h"
#import "Alarm.h"
#import "User.h"


#define ObserveInSettingVC @"ObserveInSettingVC"

#define SUN 0
#define MON 1
#define TUE 2
#define WED 3
#define THU 4
#define FRI 5
#define SAT 6

#define Center CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)

#define RADIUS ((IPHONE4S) ? 96 : 115.0)

#define MinDistance ((IPHONE4S) ? 80 : 100)
#define MaxDistance ((IPHONE4S) ? 110 : 130)

typedef NS_ENUM(NSInteger, PositionOnCircle)
{
    PositionOnCircleError = 0,
    PositionOnCircle_RightTop = 1,
    PositionOnCircle_RightBottom = 2,
    PositionOnCircle_LeftBottom = 3,
    PositionOnCircle_LeftTop = 4
};

@interface AlarmSettingViewController ()<UIAlertViewDelegate>


@end

@implementation AlarmSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        shouldReset = YES;
        
        settingDays = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0,@0,@0,@0]];
        
        currentTime = [CurrentTime shareInstance];
        
        [currentTime addObserver:self forKeyPath:@"currentSeconds" options:NSKeyValueObservingOptionNew context:ObserveInSettingVC];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimeLabel) name:SetTimeLabel object:nil];
    }
    return self;
}

- (void)dealloc
{
    [minDotsView.layer removeAllAnimations];
    [currentTime removeObserver:self forKeyPath:@"currentSeconds"];
    [selectMusicVC removeObserver:self forKeyPath:@"musicName"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SetTimeLabel object:nil];
}

#pragma kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *contextStr = (__bridge NSString*)context;
    
    if ([keyPath isEqualToString:@"currentSeconds"] &&
        [contextStr isEqualToString:ObserveInSettingVC])
    {
        if ([[change objectForKey:@"new"] intValue] == 1 )
        {
            [self setTimeLabel];
        }
    }
    
    else if ([keyPath isEqualToString:@"musicName"])
    {
        [self updateMusicButton:[change objectForKey:@"new"]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    sunButton.tag = SUN;
    monButton.tag = MON;
    tueButton.tag = TUE;
    wedButton.tag = WED;
    thuButton.tag = THU;
    friButton.tag = FRI;
    satButton.tag = SAT;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IPHONE4S)
    {
        cancelButton.top = 14;
        fixButton.top = 14;
        //        settingTimeLable.top = 14;
        [background setHidden:YES];
        [background4s setFrame:CGRectMake(0, 0, 320, 480)];
        [self.view insertSubview:background4s atIndex:0];
        
        [sunLightsView setFrame:CGRectMake(140, 160, sunLightsView.width, sunLightsView.height)];
        [self.view addSubview:sunLightsView];
        
        [minDotsView setImage:[minDotsView image]];
        [minDotsView setFrame:CGRectMake(0,0, 208, 208)];
        [minDotsView setCenter:CGPointMake(160, 240)];
        
        [hourButton setTop:230];
        [minButton setTop:230];
        
        [musicButton setTop:(musicLabel.top + 5)];
        
        [settingTimeLable setTop:75];
        
    }
    
    [self setTimeLabel];
    
    [self startAnimation];
    [self showSettingWithAnimation];
    
    if (self.isResetAlarm)
    {
        [self updateAlarmInfos];
    }
}


- (void)updateAlarmInfos
{
    if (self.alarm)
    {
        if (self.alarm.alarmMin < 10)
        {
            [settingTimeLable setText:[NSString stringWithFormat:@"%d:0%d",self.alarm.alarmHour,self.alarm.alarmMin]];
        }
        
        else
        {
            [settingTimeLable setText:[NSString stringWithFormat:@"%d:%d",self.alarm.alarmHour,self.alarm.alarmMin]];
        }
        
        settingDays = [NSMutableArray arrayWithArray:self.alarm.alarmDays];
        for (int i=0; i<7; i++)
        {
            NSNumber *day = [settingDays objectAtIndex:i];
            if ([day isEqualToNumber:@1])
            {
                switch (i)
                {
                    case 0:
                    {
                        [sunButton updateButtonBackground];
                        break;
                    }
                    case 1:
                    {
                        [monButton updateButtonBackground];
                        break;
                    }
                    case 2:
                    {
                        [tueButton updateButtonBackground];
                        break;
                    }
                    case 3:
                    {
                        [wedButton updateButtonBackground];
                        break;
                    }
                    case 4:
                    {
                        [thuButton updateButtonBackground];
                        break;
                    }
                    case 5:
                    {
                        [friButton updateButtonBackground];
                        break;
                    }
                    case 6:
                    {
                        [satButton updateButtonBackground];
                        break;
                    }
                        
                    default:
                        break;
                }
            }
        }
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    shouldEnd = NO;
    isMoved = YES;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint beginPosition = [touch locationInView:self.view];
    
    NSInteger distance = [self distanceFromPoint:beginPosition ToPoint:Center];
    
    if ( distance >= MinDistance && distance <= MaxDistance && !isAnimating)
    {
        shouldBegin = YES;
        
        NSInteger angle = [self centerCircleAnglesWithEndPoint:[self switchToCenterPoint:beginPosition]];
        
        totalAngles = angle;
        lastTotalAngles = totalAngles;
        
        if (!dotView)
        {
            if (IPHONE4S)
            {
                UIImage *image = [UIImage imageNamed:@"dot4s"];
                dotView = [[UIImageView alloc] initWithImage:image];
                [dotView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
                [dotView setCenter:Center];
            }
            
            else
            {
                dotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
                [dotView setCenter:Center];
            }
            
            [self.view addSubview:dotView];
            dotView.hidden = YES;
        }
        
        [self rotateDotView:^{
            [dotView setHidden:NO];
        }];
        
        [self updateSettingTimeLableText];
        
        prePosition = beginPosition;
    }
    
    else
    {
        shouldBegin = NO;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    shouldEnd = NO;
    
    if (shouldBegin)
    {
        UITouch *touch = [touches anyObject];
        
        newPosition = [touch locationInView:self.view];
        
        NSInteger newAngles = [self centerCircleAnglesWithEndPoint:[self switchToCenterPoint:newPosition]];
        
        NSInteger preAngles = [self centerCircleAnglesWithEndPoint:[self switchToCenterPoint:prePosition]];
        
        
        if ( fabs(newAngles - preAngles) >= 6 || (totalAngles == 0 && newAngles == 0))
        {
            if ((newAngles >= 180 && preAngles <30) || (preAngles > 180 && (newAngles >= 0 && newAngles < 30)))
            {
                totalAngles = newAngles;
            }
            
            else
            {
                totalAngles += newAngles - preAngles;
            }
            
            if (totalAngles == 360)
            {
                totalAngles = 0;
            }
            
            [self rotateDotView:nil];
            
            prePosition = newPosition;
            
            [self updateCount];
            lastTotalAngles = totalAngles;
            
            [self updateSettingTimeLableText];
            
        }
        
    }
    
}

- (void)updateCount
{
    if (isPerHour && totalAngles != lastTotalAngles)
    {
        if (totalAngles == 0)
        {
            hoursCount = (( hoursCount == 1) ? (hoursCount-1) : (hoursCount+1));
        }
        
        else if (lastTotalAngles >= 300 && (totalAngles >0 && totalAngles < 90))
        {
            hoursCount = (( hoursCount == 1) ? (hoursCount-1) : (hoursCount +1));
        }
        
        else if (totalAngles >= 300 && (lastTotalAngles >0 && lastTotalAngles < 90))
        {
            hoursCount = (( hoursCount == 1) ? (hoursCount-1) : (hoursCount +1));
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    shouldEnd = YES;
    if (shouldBegin)
    {
        [dotView setHidden:YES];
    }
}

- (CGPoint)switchToCenterPoint:(CGPoint )locationInView
{
    CGPoint location = CGPointZero;
    
    CGFloat radiusSquare =
    powf((locationInView.x - Center.x), 2) + powf((locationInView.y -Center.y), 2);
    
    CGFloat Radius = powf(radiusSquare, 0.5);
    
    BOOL isEmbedded = ((Radius < RADIUS) ? YES : NO);
    
    CGFloat Height = fabsf(locationInView.y - Center.y);
    
    CGFloat Width = fabsf(locationInView.x - Center.x);
    
    CGFloat height = fabsf(Radius - RADIUS)*Height/Radius;
    
    CGFloat width = fabsf(Radius - RADIUS)*Width/Radius;
    
    NSInteger position = [self positionOnCircel:locationInView];
    
    if ( position == PositionOnCircle_LeftTop)
    {
        //左上
        location = ( (isEmbedded) ? CGPointMake(locationInView.x - width, locationInView.y - height) : CGPointMake(locationInView.x + width, locationInView.y + height));
    }
    
    else if (position == PositionOnCircle_RightTop)
    {
        //右上
        location = ( (isEmbedded) ? CGPointMake(locationInView.x + width, locationInView.y - height) : CGPointMake(locationInView.x - width, locationInView.y + height));
    }
    
    else if (position == PositionOnCircle_LeftBottom)
    {
        //左下
        location = ( (isEmbedded) ? CGPointMake(locationInView.x - width, locationInView.y + height) : CGPointMake(locationInView.x + width, locationInView.y - height));
    }
    
    else if (position == PositionOnCircle_RightBottom)
    {
        //右下
        location = ( (isEmbedded) ? CGPointMake(locationInView.x + width, locationInView.y + height) : CGPointMake(locationInView.x - width, locationInView.y - height));
    }
    
    return location;
}

- (void)startAnimation
{
//    CGAffineTransform transform = minDotsView.transform;
//
//    minDotsView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//    minDotsView.hidden = NO;
//    
//    [UIView beginAnimations:nil context:NULL];
//    
//    [UIView setAnimationDuration:0.5f];
//    
//    minDotsView.transform = transform;
//    
//    [UIView commitAnimations];
    
    minDotsView.hidden = NO;
    
    CABasicAnimation *bAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [bAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [bAnimation setToValue:[NSNumber numberWithFloat:(2*M_PI)]];
    [bAnimation setDuration:0.35f];
    
    [minDotsView.layer addAnimation:bAnimation forKey:@"rotation"];
    
}
//TO MODIFY
- (void)showSettingWithAnimation
{
    if (!selectedButtonView)
    {
        selectedButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedBV"]];
        [selectedButtonView setLeft:320];
        [selectedButtonView setTop:minButton.top];
        selectedButtonView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        [self.view addSubview:selectedButtonView];
    }
    
    [UIView animateWithDuration:0 animations:^{
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.35f animations:^{
            
            cancelButton.left = 20;
            fixButton.left = 228;
            musicLabel.left = 20;
            sunButton.left = 22;
            monButton.left = 64;
            tueButton.left = 116;
            wedButton.left = 154;
            thuButton.left = 202;
            friButton.left = 241;
            satButton.left = 271;
            
            [musicButton setLeft:100];
            
            settingTimeLable.centerX = self.view.width*0.5;
            
            if (self.isResetAlarm)
            {
                stopButton.left = 20;
                deleteButton.left = 228;
            }
            
            [selectedButtonView setFrame:minButton.frame];
            
        }completion:^(BOOL finished) {
            
        }];
        
    }];
}

- (void)hideSettingWithAnimation
{
    [UIView animateWithDuration:0.35f animations:^{
        
        cancelButton.left = 380;
        fixButton.left = 380;
        musicLabel.left = 380;
        sunButton.left = 380;
        monButton.left = 380;
        tueButton.left = 380;
        wedButton.left = 380;
        thuButton.left = 380;
        friButton.left = 380;
        satButton.left = 380;
        
        [musicButton setLeft:380];
        
        settingTimeLable.left = 380;
        [selectedButtonView setLeft:380];
        
        [settingTimeLable setLeft:380];
        
        if (self.isResetAlarm)
        {
            stopButton.left = 380;
            deleteButton.left = 380;
        }
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

- (IBAction)showPresentingVC:(id)sender
{
    [self hideSettingWithAnimation];
    
    [self startAnimation];
}

- (void)setTimeLabel
{
    NSString *min;
    NSString *hour;
    if (currentTime.currentMins < 10)
    {
        min = [NSString stringWithFormat:@"0%d",currentTime.currentMins];
    }
    
    else
    {
        min = [NSString stringWithFormat:@"%d",currentTime.currentMins];
    }
    
    if (currentTime.currentHours < 10)
    {
        hour = [NSString stringWithFormat:@" %d:",currentTime.currentHours];
    }
    
    else
    {
        hour = [NSString stringWithFormat:@"%d:",currentTime.currentHours];
    }
    
    [hourButton setTitle:hour forState:UIControlStateNormal];
    [minButton setTitle:min forState:UIControlStateNormal];
}

- (void)updateSettingTimeLableText
{
    NSInteger hours;
    NSInteger mins;
    
    if (shouldReset)
    {
        if (currentTime.currentHours > 11)
        {
            hoursCount = 1;
        }
        
        hours = ((isPerHour) ? ((totalAngles+hoursCount*360)/30) : currentTime.currentHours);

        mins = ((!isPerHour) ? (totalAngles/6) : currentTime.currentMins);
        
        settingHours = hours;
        settingMins = mins;
        shouldReset = NO;
    }
    
    else
    {
        hours = ((isPerHour) ? ((totalAngles + hoursCount*360)/30) : settingHours);

        mins = ((!isPerHour) ? (totalAngles/6) : settingMins);
        
        if (isPerHour)
        {
            settingHours = hours;
        }
        else
        {
            settingMins = mins;
        }
    }
    
    if (mins < 10)
    {
        [settingTimeLable setText:[NSString stringWithFormat:@"%d:0%d",hours,mins]];
    }
    
    else
    {
        [settingTimeLable setText:[NSString stringWithFormat:@"%d:%d",hours,mins]];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)selectDays:(id)sender
{
    Button *button = sender;
    
    switch (button.tag)
    {
        case SUN:
        {
            settingDays[SUN] = ((sunButton.selected) ? @0 : @1);
            [sunButton updateButtonBackground];
            break;
        }
        case MON:
        {
            settingDays[MON] = ((monButton.selected) ? @0 : @1);
            [monButton updateButtonBackground];
            break;
        }
        case TUE:
        {
            settingDays[TUE] = ((tueButton.selected) ? @0 : @1);
            [tueButton updateButtonBackground];
            break;
        }
        case WED:
        {
            settingDays[WED] = ((wedButton.selected) ? @0 : @1);
            [wedButton updateButtonBackground];
            break;
        }
        case THU:
        {
            settingDays[THU] = ((thuButton.selected) ? @0 : @1);
            [thuButton updateButtonBackground];
            break;
        }
        case FRI:
        {
            settingDays[FRI] = ((friButton.selected) ? @0 : @1);
            [friButton updateButtonBackground];
            break;
        }
        case SAT:
        {
            settingDays[SAT] = ((satButton.selected) ? @0 : @1);
            [satButton updateButtonBackground];
            break;
        }
            
        default:
            break;
    }
}

- (NSInteger)positionOnCircel:(CGPoint)point
{
    if ( point.x <= Center.x && point.y <= Center.y)
    {
        //左上
        return PositionOnCircle_LeftTop;
    }
    
    else if (point.x > Center.x && point.y <= Center.y)
    {
        //右上
        return PositionOnCircle_RightTop;
    }
    
    else if (point.x <= Center.x && point.y > Center.y)
    {
        //左下
        return PositionOnCircle_LeftBottom;
    }
    
    else if (point.x > Center.x && point.y > Center.y)
    {
        //右下
        return PositionOnCircle_RightBottom;
    }
    
    return PositionOnCircleError;
}

- (NSInteger)centerCircleAnglesWithEndPoint:(CGPoint)point
{
    CGFloat cosine =  1 - (powf((Center.y - RADIUS - point.y), 2) + powf((Center.x - point.x), 2))/(2*powf(RADIUS, 2));
    
    NSInteger angle = (NSInteger)(acosf(cosine)*180/M_PI);

    angle = ((angle/3 + 1)/2)*6;
    
    PositionOnCircle position = [self positionOnCircel:point];
    
    if (position == PositionOnCircle_LeftBottom || position == PositionOnCircle_LeftTop)
    {
        if (angle != 0)
        {
            angle = 360 - angle;
        }
    }
    
    return angle;
}

- (float)distanceFromPoint:(CGPoint)beginPoint ToPoint:(CGPoint)endPoint
{
    float distance = powf((powf(beginPoint.x - endPoint.x, 2) + powf(beginPoint.y - endPoint.y, 2)), 0.5);
    return distance;
}

- (void)rotateDotView:(void (^)(void))completion
{
    isAnimating = YES;
    CGAffineTransform transform = CGAffineTransformMakeRotation(totalAngles*M_PI/180.0);
    
    [UIView animateWithDuration:0.2 animations:^{
        dotView.transform = transform;
    } completion:^(BOOL finished) {
        if (completion)
        {
            completion();
        }
        isAnimating = NO;
        if (shouldEnd)
        {
            [dotView setHidden:YES];
        }
    }];
}

- (IBAction)selectTimeUnit:(id)sender
{
    UIButton *button = sender;
    if (button.tag == 0)
    {
        //perHour
        isPerHour = YES;
        [UIView animateWithDuration:0.2 animations:^{
            
            [selectedButtonView setFrame:CGRectMake(hourButton.left, hourButton.top, 50, hourButton.height)];
        }];
    }
    
    else if (button.tag == 1)
    {
        isPerHour = NO;
        //perMin
        [UIView animateWithDuration:0.2 animations:^{
            
            [selectedButtonView setFrame:minButton.frame];
        }];
    }
}

- (IBAction)fixAlarm:(id)sender
{
    BOOL shouldHide = YES;
    
    if (self.isResetAlarm)
    {
        NSString *ID = [NSString stringWithFormat:@"%d%d",settingHours,settingMins];
        
        if (![[User shareInstance] isAlarmExist:ID] || [ID isEqualToString:self.alarm.alarmID])
        {
            self.alarm.alarmDays = settingDays;
            self.alarm.alarmMusicName = musicButton.titleLabel.text;
            
            if (isMoved)
            {
                self.alarm.alarmHour = settingHours;
                self.alarm.alarmMin = settingMins;
            }
            
            
            User *user = [User shareInstance];
            [user modifyAlarm:self.alarm];
        }
        
        else 
        {
            shouldHide = NO;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"这个时间点已设置过了" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
            
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.0];
        }
    }
    
    else
    {
        NSMutableDictionary *alarmDic = [[NSMutableDictionary alloc] init];
        
        [alarmDic setValue:[NSNumber numberWithInteger:settingHours] forKey:ALARMHOUR];
        [alarmDic setValue:[NSNumber numberWithInteger:settingMins] forKey:ALARMMIN];
        
        
        [alarmDic setValue:settingDays forKey:ALARMDAYS];
        [alarmDic setValue:musicButton.titleLabel.text forKey:ALARMMUSIC];
        
        Alarm *alarm = [Alarm createWithDic:alarmDic];
        
        if (alarm)
        {
            User *user = [User shareInstance];
            [user addAlarm:alarm];
        }
        
        else
        {
            shouldHide = NO;
            NSLog(@"already exsit");
        }
    }
    
    if (shouldHide)
    {
        [self hideSettingWithAnimation];
    }
}

- (IBAction)clickStopButton:(id)sender
{
    self.alarm.shouldSound = NO;
    [[User shareInstance] modifyAlarm:self.alarm];
    [self showPresentingVC:stopButton];
}

- (IBAction)clickDeleteButton:(id)sender
{
    [[User shareInstance] removeAlarmByID:self.alarm.alarmID];
    [self showPresentingVC:deleteButton];
}

- (IBAction)clickMusicButton:(id)sender
{
    if (!selectMusicVC)
    {
        selectMusicVC = [[SelectMusicViewController alloc] initWithNibName:@"SelectMusicViewController" bundle:nil];
        
        [selectMusicVC addObserver:self forKeyPath:@"musicName" options:NSKeyValueObservingOptionNew context:NULL];
        
        [selectMusicVC setSelectedMusic:musicButton.titleLabel.text];
    }
    
    [self presentViewController:selectMusicVC animated:NO completion:^{
        
    }];
}

- (void)updateMusicButton:(NSString *)music
{
    [musicButton setTitle:music forState:UIControlStateNormal];
}

#pragma UIAlertViewDelegate

- (void)dismissAlertView:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
