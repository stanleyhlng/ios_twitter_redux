//
//  UserTimelineViewController.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserTimelineViewController;

@protocol UserTimelineViewControllerDelegate <NSObject>
- (void)composeFromUserTimelineView:(UserTimelineViewController *)controller message:(NSString *)message;
- (void)longPressFromUserTimelineView:(UserTimelineViewController *)controller message:(NSString *)message;

@end

@interface UserTimelineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) id <UserTimelineViewControllerDelegate> delegate;

@end
