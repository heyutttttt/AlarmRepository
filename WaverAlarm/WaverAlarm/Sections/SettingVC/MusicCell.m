//
//  MusicCell.m
//  WaverAlarm
//
//  Created by ryan on 14-5-5.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)awakeFromNib
{
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [tapView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMusic:(NSString *)text
{
    [musicLabel setText:text];
}

- (void)setTapViewHidden:(BOOL)shouldHide
{
    [tapView setHidden:shouldHide];
}
@end
