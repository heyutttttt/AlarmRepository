//
//  MainViewController.m
//  WaverAlarm
//
//  Created by ryan on 14-4-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "MainViewController.h"
#import "AlarmSettingViewController.h"
#import "User.h"
#import "AlarmCell.h"

#define ObserveInMainVC @"ObserveInMainVC"
#define ALARMCELL @"ALARMCELL"

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *alarmCollectionView;
    NSMutableArray *data;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimeLabel) name:SetTimeLabel object:nil];
    }
    return self;
}

- (void)dealloc
{
    [currentTime removeObserver:self forKeyPath:@"currentSeconds"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SetTimeLabel object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    currentTime = [CurrentTime shareInstance];
    
    [currentTime addObserver:self forKeyPath:@"currentSeconds" options:NSKeyValueObservingOptionNew context:ObserveInMainVC];
    
    [self setTimeLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IPHONE4S)
    {
        [background setHidden:YES];
        
        [background4s setFrame:CGRectMake(0, 0, 320, 480)];
        [self.view insertSubview:background4s atIndex:0];
        
        [sunLightsView setFrame:CGRectMake(140, 160, sunLightsView.width, sunLightsView.height)];
        [addButton setFrame:CGRectMake(135, 280, addButton.width, addButton.height)];
        
        [hourButton setTop:230];
        [minButton setTop:230];
    }
    
    [self setTimeLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[User shareInstance] descri];
    
    [self createCollectionView];
    
    if (![[User shareInstance] isAlarmsEmpty])
    {
        [UIView animateWithDuration:0.35f delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            if (![[User shareInstance] isNoAlarmShouldSound])
            {
                [alarmTapView setRight:300];
            }
            
            [alarmCollectionView setLeft:0];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *contextStr = (__bridge NSString*)context;
    if ([keyPath isEqualToString:@"currentSeconds"] &&
        [contextStr isEqualToString:ObserveInMainVC])
    {
        [self updateTime];
    }
}


- (void)updateTime
{
    if (currentTime.currentSeconds == 1)
    {
        angle = 0;
        [self startRevolveAnimation];
        [self setTimeLabel];
    }
    
    else
    {
        [self startZoomInAnimation];
    }
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

- (void)startRevolveAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
        sunLightsView.transform = endAngle;
                         
    } completion:^(BOOL finished) {
        if (angle == 360)
        {
            angle = 0;
        }
        
        else
        {
            angle += 10;
            [self startRevolveAnimation];
        }
    }];
}

- (void)startZoomInAnimation
{
    [UIView beginAnimations:nil context:NULL];
    sunLightsView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDidStopSelector:@selector(startZoomOutAnamation)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)startZoomOutAnamation
{
    [UIView beginAnimations:nil context:NULL];
    sunLightsView.transform = CGAffineTransformIdentity;
    [UIView setAnimationDuration:0.02];
    [UIView commitAnimations];
}

- (IBAction)showAlarmSetting:(id)sender
{
    AlarmSettingViewController *vc = [[AlarmSettingViewController alloc] initWithNibName:@"AlarmSettingViewController" bundle:nil];
    
    [UIView animateWithDuration:0.38f animations:^{
        
        [alarmTapView setLeft:380];
        if (alarmCollectionView)
        {
            [alarmCollectionView setLeft:380];
        }
        
    } completion:^(BOOL finished) {
        
        [self presentViewController:vc animated:NO completion:^{
            
        }];

    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionView

- (void)reloadCollectionViewData
{
    if (alarmCollectionView)
    {
        data = [[User shareInstance] getAllAlarms];
        [alarmCollectionView reloadData];
    }
}

- (void)createCollectionView
{
    if (![[User shareInstance] isAlarmsEmpty])
    {
        if (!alarmCollectionView)
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.itemSize=CGSizeMake(65,64);
            flowLayout.sectionInset = UIEdgeInsetsMake(0,30,0,0);
//            flowLayout.minimumInteritemSpacing = 60;
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            
            alarmCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, 255, 90) collectionViewLayout:flowLayout];
            alarmCollectionView.backgroundColor = [UIColor clearColor];
            alarmCollectionView.delegate = self;
            alarmCollectionView.dataSource = self;
            alarmCollectionView.pagingEnabled = YES;
            [alarmCollectionView setScrollsToTop:NO];
            
            [alarmCollectionView registerClass:[AlarmCell class] forCellWithReuseIdentifier:ALARMCELL];
            
            data = [[User shareInstance] getAllAlarms];
            
            [self.view addSubview:alarmCollectionView];
        }
        
        else
        {
            data = [[User shareInstance] getAllAlarms];
            [alarmCollectionView reloadData];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmCell *alarmCell = (AlarmCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ALARMCELL forIndexPath:indexPath];
//    alarmCell.delegate = self;
    Alarm *alarm = [data objectAtIndex:indexPath.item];
    
    [alarmCell setAlarm:alarm];
    [alarmCell updateTimeLabel];
    
    return alarmCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Alarm *alarm = [data objectAtIndex:indexPath.item];
    
    AlarmSettingViewController *vc = [[AlarmSettingViewController alloc] initWithNibName:@"AlarmSettingViewController" bundle:nil];
    
    vc.isResetAlarm = YES;
    vc.alarm = alarm;
    
    [UIView animateWithDuration:0.38f animations:^{
        
        [alarmTapView setLeft:380];
        if (alarmCollectionView)
        {
            [alarmCollectionView setLeft:380];
        }
        
    } completion:^(BOOL finished) {
        
        [self presentViewController:vc animated:NO completion:^{
            
        }];
        
    }];
}

//#pragma CollectionViewDelegate
//
//- (void)reload
//{
//    data = [[User shareInstance] getAllAlarms];
//    [alarmCollectionView reloadData];
//}

@end
