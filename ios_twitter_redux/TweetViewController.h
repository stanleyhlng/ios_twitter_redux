//
//  TweetViewController.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/12/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetViewController : UIViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Tweet* tweet;

@end
