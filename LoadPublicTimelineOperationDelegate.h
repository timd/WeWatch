//
//  LoadPublicTimelineOperationDelegate.h
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadPublicTimelineOperationDelegate
@required
-(void)loadPublicTimelineOperation:(NSOperation *)theOperation publicTimelineDidLoad:(NSArray *)thePublicTimeline;

@end
