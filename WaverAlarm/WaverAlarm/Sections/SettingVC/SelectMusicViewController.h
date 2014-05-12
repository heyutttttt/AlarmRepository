//
//  SelectMusicViewController.h
//  WaverAlarm
//
//  Created by ryan on 14-5-5.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectMusicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *myTableView;
    IBOutlet UIButton *cancelButton;
    NSMutableArray *data;
    
    NSIndexPath *lastIndexPath;
    int alarmRow;
    
    BOOL isResetAlarmInfo;
}

@property (nonatomic ,strong) NSString *musicName;

- (void)setSelectedMusic:(NSString *)music;

@end
