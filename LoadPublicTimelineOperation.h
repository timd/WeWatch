//
//  LoadPublicTimelineOperation.h
//  DrillDown
//
//  Created by Aral Balkan on 22/07/2010.
//  Copyright 2010 Naklab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadPublicTimelineOperationDelegate.h"

@interface LoadPublicTimelineOperation : NSOperation {
	id <LoadPublicTimelineOperationDelegate> delegate;
}

@property (nonatomic, assign) id <LoadPublicTimelineOperationDelegate> delegate;

@end











