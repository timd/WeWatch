//
//  LoadPublicTimelineOperation.h
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadPublicTimelineOperationDelegate.h"
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterController;

@interface LoadPublicTimelineOperation : NSOperation {
	id <LoadPublicTimelineOperationDelegate> delegate;

    // ivar to hold twitter name passed in from calling methods
    NSString *twitterName;
    
    // ivar to hold the twitter engine object
    SA_OAuthTwitterEngine *_engine;
    
}

@property (nonatomic, assign) id <LoadPublicTimelineOperationDelegate> delegate;
@property (retain) NSString *twitterName;
@property (retain) SA_OAuthTwitterEngine *_engine;

-(id)initWithTwitterName:(NSString *)name;

-(NSArray *)parseRawScheduleWith:(NSArray *)rawData;
@end











