//
//  TweetTableViewCell.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/14/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <DateTools.h>
#import "AVHexColor.h"

@interface TweetTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidthConstraint;
- (void)setupProfileImageView;
- (void)setupDateLabel;
- (void)setupNameLabel;
- (void)setupScreenNameLabel;
- (void)setupStatusTextLabel;
@end

@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure
{
    if (self.tweet == nil) {
        return;
    }
    
    [self setupProfileImageView];
    
    [self setupNameLabel];
    [self setupScreenNameLabel];
    [self setupDateLabel];
    
    [self setupStatusTextLabel];
}

- (void)setupProfileImageView
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }
    
    NSURL *url = user.profileImageUrl;
    UIImage *placeholder = [UIImage imageNamed:@"profile"];
    
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 5.0f;
    
    [self.profileImageView setImageWithURL:url placeholderImage:placeholder];
    /*
     self.profileImageView.alpha = 0.5f;
     
     [self.profileImageView setImageWithURL:url
     placeholderImage:placeholder
     options:SDWebImageRefreshCached
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
     // Fade in image
     [UIView beginAnimations:@"fade in" context:nil];
     [UIView setAnimationDuration:0.5];
     [self.profileImageView setAlpha:1.0f];
     [UIView commitAnimations];
     }
     usingActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
     */
}

- (void)setupDateLabel
{
    NSDateFormatter *frm = [[NSDateFormatter alloc] init];
    [frm setDateStyle:NSDateFormatterLongStyle];
    [frm setFormatterBehavior:NSDateFormatterBehavior10_4];
    [frm setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *createdDate = [frm dateFromString:self.tweet.createdAt];
    //NSLog(@"oldDate:%@", self.tweet.createdAt);
    //NSLog(@"newDate:%@", createdDate);
    
    NSDate *timeAgoDate = createdDate;
    
    self.dateLabel.font = [UIFont systemFontOfSize:13.0f];
    self.dateLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", timeAgoDate.shortTimeAgoSinceNow];
}

- (void)setupNameLabel
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.text = user.name;
    [self.nameLabel sizeToFit];
    
    CGRect frame = self.nameLabel.frame;
    self.nameLabelWidthConstraint.constant = frame.size.width;
}

- (void)setupScreenNameLabel
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }
    
    self.screenNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.screenNameLabel.text = [@"@" stringByAppendingString:user.screenName];
}

- (void)setupStatusTextLabel
{
    NSString *text = self.tweet.text;
    if (self.tweet.retweetedStatus != nil) {
        text = self.tweet.retweetedStatus.text;
    }
    
    self.statusTextLabel.font = [UIFont systemFontOfSize:14.0f];
    self.statusTextLabel.text = text;
}

@end
