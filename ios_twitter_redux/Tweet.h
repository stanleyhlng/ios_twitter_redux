//
//  Tweet.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/13/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <Mantle.h>

@class Tweet;
@class User;

@interface Tweet : MTLModel<MTLJSONSerializing>

// Tweet Object Documentation
// https://dev.twitter.com/docs/platform-objects/tweets

@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *favorited;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, strong) NSNumber *inReplyToStatusId;
@property (nonatomic, strong) NSNumber *inReplyToUserId;
@property (nonatomic, strong) NSNumber *retweetCount;
@property (nonatomic, strong) NSNumber *retweeted;
@property (nonatomic, strong) Tweet *retweetedStatus;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;

+ (NSValueTransformer *)retweetedStatusJSONTransformer;
+ (NSValueTransformer *)userJSONTransformer;
+ (Tweet *)parseTweet:(id)response;
+ (NSArray *)parseTweets:(id)response;

@end