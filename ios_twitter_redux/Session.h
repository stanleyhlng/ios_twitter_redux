//
//  Session.h
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/13/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Session : NSObject

+ (Session *)instance;

- (User *)getUser;
- (void)setUser:(User *)user;

- (void)addAccountWithKey:(NSString *)key val:(NSDictionary *)val;
- (NSMutableDictionary *)getAccounts;

@end
