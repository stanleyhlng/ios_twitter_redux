//
//  Session.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/13/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "Session.h"

@implementation Session

static User* currentUser = nil;
static NSMutableDictionary* accounts = nil;

+ (Session *)instance {
    static Session *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[Session alloc] init];
        }
    });
    
    return instance;
}

- (User *)getUser {
    return currentUser;
}

- (void)setUser:(User *)user {
    currentUser = user;
}

- (void)addAccountWithKey:(NSString *)key val:(NSDictionary *)val
{
    if (accounts == nil) {
        accounts = [[NSMutableDictionary alloc] init];
    }
    
    if ([accounts objectForKey:key] == nil) {
        accounts[key] = val;
    }
    else {
        NSLog(@"[session] account exists! key=%@", key);
    }
}

- (NSMutableDictionary *)getAccounts
{
    return accounts;
}

@end
