//
//  Button.m
//  WaverAlarm
//
//  Created by ryan on 14-4-26.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Button.h"

@implementation Button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelectedView
{
    if (!selectedBackgroundView)
    {
        selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [selectedBackgroundView setImage:[UIImage imageNamed:@"underLine"]];
    }
    
    [self insertSubview:selectedBackgroundView atIndex:0];
    
//    selectedBackgroundView.width = 1;
//    selectedBackgroundView.centerX = self.width/2.0;
    
    selectedBackgroundView.width = 0;
    selectedBackgroundView.left = self.width;
    [UIView animateWithDuration:0.2 animations:^{
        
        [selectedBackgroundView setFrame:CGRectMake(0, selectedBackgroundView.top, self.width, selectedBackgroundView.height)];
//        selectedBackgroundView.width = self.width;
//        selectedBackgroundView.centerX = self.width /2.0;
    }];
}

- (void)removeSelectedView
{
    if (selectedBackgroundView)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            [selectedBackgroundView setFrame:CGRectMake(self.width, selectedBackgroundView.top, 0, selectedBackgroundView.height)];
        } completion:^(BOOL finished) {
            
            [selectedBackgroundView removeFromSuperview];
        }];
    }
}

- (void)updateButtonBackground
{
    if (self.selected)
    {
        [self removeSelectedView];
        [self setSelected:NO];
    }
    
    else
    {
        [self setSelectedView];
        [self setSelected:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
