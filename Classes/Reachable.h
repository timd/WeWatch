//
//  Reachable.h
//  WeWatch
//
//  Created by Tim Duckett on 04/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface Reachable : NSObject {
    
    Reachability* internetReachable;
    Reachability* hostReachable;
}

-(BOOL)isReachable;
-(BOOL)hostAvailable:(NSString *)theHost;

@end
