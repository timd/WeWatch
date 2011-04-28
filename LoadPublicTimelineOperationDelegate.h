//
//  LoadPublicTimelineOperationDelegate.h
//  DrillDown
//
//  Created by Aral Balkan on 22/07/2010.
//  Copyright 2010 Naklab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadPublicTimelineOperationDelegate
@required
-(void)loadPublicTimelineOperation:(NSOperation *)theOperation publicTimelineDidLoad:(NSArray *)thePublicTimeline;

@end
