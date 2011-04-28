//
//  RootViewController.h
//  DrillDown
//
//  Created by Aral Balkan on 21/07/2010.
//  Copyright Naklab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadPublicTimelineOperationDelegate.h"

@class LoadPublicTimelineOperation;

@interface RootViewController : UITableViewController <LoadPublicTimelineOperationDelegate> {
	
	LoadPublicTimelineOperation *loadPublicTimelineOperation;
}

@property (nonatomic, retain) NSArray *tweetsArray;
@property (nonatomic, retain) LoadPublicTimelineOperation *loadPublicTimelineOperation;

@end






