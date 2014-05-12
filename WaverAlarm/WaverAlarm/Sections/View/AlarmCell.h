//
//  AlarmCell.h
//  WaverAlarm
//
//  Created by ryan on 14-5-4.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@protocol CollectionViewCellReloadDataDelegate <NSObject>

- (void)reload;

@end

@interface AlarmCell : UICollectionViewCell
{
    UIImageView *bgView;
    UILabel *timeLabel;
    
    UIImageView *deleteView;
    
    UIImageView *offView;
    
    BOOL shouldDelete;
    BOOL isCancel;
    
    Alarm *alarm;
}

@property (nonatomic, assign) id<CollectionViewCellReloadDataDelegate> delegate;

- (void)updateTimeLabel;
- (void)setAlarm:(Alarm *)newAlarm;

@end
