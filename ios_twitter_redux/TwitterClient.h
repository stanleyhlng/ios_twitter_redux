//
//  TwitterClient.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/13/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient *)instance;

#pragma TIMELINES methods

#pragma TWEETS methods

#pragma FAVORITES methods

#pragma USERS methods

#pragma OAUTH methods

#pragma HELPERS methods

@end
