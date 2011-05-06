//
//  LoadPublicTimelineOperation.h
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadPublicTimelineOperationDelegate.h"

@interface LoadPublicTimelineOperation : NSOperation {
	id <LoadPublicTimelineOperationDelegate> delegate;
    NSString *twitterName;
}

@property (nonatomic, assign) id <LoadPublicTimelineOperationDelegate> delegate;
@property (retain) NSString *twitterName;


-(id)initWithTwitterName:(NSString *)name;

-(NSArray *)parseRawScheduleWith:(NSArray *)rawData;

@end











