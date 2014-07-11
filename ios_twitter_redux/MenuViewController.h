//
//  MenuViewController.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"
#import "HomeTimelineViewController.h"
#import "MentionsTimelineViewController.h"
#import "UserTimelineViewController.h"

@interface MenuViewController : AMSlideMenuLeftTableViewController<
    HomeTimelineViewControllerDelegate,
    MentionsTimelineViewControllerDelegate,
    UserTimelineViewControllerDelegate>

@end
