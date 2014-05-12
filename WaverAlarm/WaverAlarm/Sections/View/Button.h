//
//  Button.h
//  WaverAlarm
//
//  Created by ryan on 14-4-26.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Button : UIButton
{
    UIImageView *selectedBackgroundView;
}

- (void)updateButtonBackground;

@end
