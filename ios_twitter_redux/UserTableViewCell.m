//
//  UserTableViewCell.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "UserTableViewCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserTableViewCell()
- (void)setupProfileImageView;
- (void)setupNameLabel;
- (void)setupScreenNameLabel;

@end

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

- (void)configure
{
    if (self.user == nil) {
        return;
    }
    
    [self setupProfileImageView];
    [self setupNameLabel];
    [self setupScreenNameLabel];
}

- (void)setupNameLabel
{
    User *user = self.user;
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.text = user.name;
    [self.nameLabel sizeToFit];
}

- (void)setupProfileImageView
{
    User *user = self.user;
    
    NSURL *url = user.profileImageUrl;
    UIImage *placeholder = [UIImage imageNamed:@"profile"];
    
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 5.0f;
    
    [self.profileImageView setImageWithURL:url placeholderImage:placeholder];
}

- (void)setupScreenNameLabel
{
    User *user = self.user;
    
    self.screenNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.screenNameLabel.text = [@"@" stringByAppendingString:user.screenName];
}

@end
