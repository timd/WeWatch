//
//  Reachable.m
//  WeWatch
//
//  Created by Tim Duckett on 04/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "Reachable.h"

@implementation Reachable

-(BOOL)isReachable {
    
    // First off, create a RestKit reachability observer based on the RKClient singleton
    RKReachabilityObserver *networkStatusObserver = [[RKClient sharedClient] baseURLReachabilityObserver];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    // Check if we can see the network before we try and update anything
    if ([networkStatusObserver isNetworkReachable]) {
        NSLog(@"Network is reachable");
        return YES;
    } else {
        NSLog(@"Network is not reachable");
        return NO;
    }   
}


@end
