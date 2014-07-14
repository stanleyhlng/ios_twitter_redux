//
//  TweetTableViewCell.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/14/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) Tweet* tweet;
- (void)configure;

@end
