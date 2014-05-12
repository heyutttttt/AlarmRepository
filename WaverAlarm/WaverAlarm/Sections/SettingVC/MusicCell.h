//
//  MusicCell.h
//  WaverAlarm
//
//  Created by ryan on 14-5-5.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCell : UITableViewCell
{
    IBOutlet UILabel *musicLabel;
    IBOutlet UIImageView *tapView;
}

- (void)setMusic:(NSString *)text;
- (void)setTapViewHidden:(BOOL)shouldHide;
@end
