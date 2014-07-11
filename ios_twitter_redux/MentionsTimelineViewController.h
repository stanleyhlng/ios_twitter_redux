//
//  MentionsTimelineViewController.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MentionsTimelineViewController;

@protocol MentionsTimelineViewControllerDelegate <NSObject>
- (void)composeFromMentionsTimelineView:(MentionsTimelineViewController *)controller message:(NSString *)message;
@end

@interface MentionsTimelineViewController : UIViewController
@property (weak, nonatomic) id <MentionsTimelineViewControllerDelegate> delegate;

@end
