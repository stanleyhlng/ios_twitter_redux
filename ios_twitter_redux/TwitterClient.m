//
//  TwitterClient.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/13/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
                                                  consumerKey:@"L82BdXwfdKHIQL036NO12qwpx"
                                               consumerSecret:@"zbBxQNTLry6add284m8AecDf5VRdIpuUpuuVu0TM41tci8a0Jd"];
        }
    });
    
    return instance;
}

#pragma TIMELINES methods

#pragma TWEETS methods

#pragma FAVORITES methods

#pragma USERS methods

#pragma OAUTH methods

#pragma HELPERS methods

@end