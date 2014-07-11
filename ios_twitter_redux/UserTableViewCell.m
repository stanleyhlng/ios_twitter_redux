//
//  UserTableViewCell.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor lightGrayColor];
    self.screenNameLabel.textColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
