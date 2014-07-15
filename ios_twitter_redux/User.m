//
//  User.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/13/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"followersCount": @"followers_count",
             @"friendsCount": @"friends_count",
             @"id": @"id",
             @"name": @"name",
             @"profileBackgroundImageUrl": @"profile_background_image_url",
             @"profileBannerUrl": @"profile_banner_url",
             @"profileImageUrl": @"profile_image_url",
             @"screenName": @"screen_name",
             @"statusesCount": @"statuses_count",
             @"tagLine": @"description"
             };
}

+ (NSValueTransformer *)profileBackgroundImageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)profileBannerUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)profileImageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (User *)parseUser:(id)response
{
    return [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:response error:nil];
}

@end