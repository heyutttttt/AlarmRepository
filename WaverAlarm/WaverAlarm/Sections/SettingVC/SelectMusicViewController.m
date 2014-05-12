//
//  SelectMusicViewController.m
//  WaverAlarm
//
//  Created by ryan on 14-5-5.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "SelectMusicViewController.h"
#import "MusicCell.h"
#import "AlarmSettingViewController.h"

@implementation SelectMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        data = [[NSMutableArray alloc] initWithObjects:@"夜空中最亮的星", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [myTableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [myTableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showTableViewAnimation];
}

- (void)showTableViewAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        
        [cancelButton setLeft:20];
        [myTableView setLeft:33];
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickCancelButton:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        
        [myTableView setLeft:380];
        [cancelButton setLeft:380];
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:^{

        }];
    }];
    
}

- (void)setSelectedMusic:(NSString *)music
{
    alarmRow = [data indexOfObject:music];
    
    isResetAlarmInfo = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell setMusic:[data objectAtIndex:indexPath.row]];
    
    if (isResetAlarmInfo)
    {
        if (indexPath.row == alarmRow)
        {
            [cell setTapViewHidden:NO];
            lastIndexPath = indexPath;
            self.musicName = [data objectAtIndex:alarmRow];
        }
    }
    
    else
    {
        if (indexPath.row == 1)
        {
            [cell setTapViewHidden:NO];
            lastIndexPath = indexPath;
            self.musicName = [data objectAtIndex:1];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCell *cell = (MusicCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setTapViewHidden:NO];
    
    MusicCell *lastCell = (MusicCell *)[tableView cellForRowAtIndexPath:lastIndexPath];
    [lastCell setTapViewHidden:YES];
    
    lastIndexPath = indexPath;

    self.musicName = [data objectAtIndex:indexPath.row];
    
    [self performSelector:@selector(clickCancelButton:) withObject:self afterDelay:0.3];
}

@end
