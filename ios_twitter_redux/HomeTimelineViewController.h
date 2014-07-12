//
//  HomeTimelineViewController.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTimelineViewController;

@protocol HomeTimelineViewControllerDelegate <NSObject>
- (void)composeFromHomeTimelineView:(HomeTimelineViewController *)controller message:(NSString *)message;
@end

@interface HomeTimelineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) id <HomeTimelineViewControllerDelegate> delegate;

@end
