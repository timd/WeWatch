//
//  RootViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright Charismatic Megafauna Ltd 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadPublicTimelineOperationDelegate.h"
#import "PullRefreshTableViewController.h"

@class LoadPublicTimelineOperation;
@class ProgrammeDetailViewController;

@interface RootViewController : PullRefreshTableViewController <LoadPublicTimelineOperationDelegate> {
	
	LoadPublicTimelineOperation *loadPublicTimelineOperation;
    
    // ivar to hold reference to an ProgrammeDetailViewController
    ProgrammeDetailViewController *programmeDetailViewController;
    
    // ivar to hold reference to a custom cell
    UITableViewCell *nibLoadedCell;

}

@property (nonatomic, retain) NSArray *tweetsArray;
@property (nonatomic, retain) NSArray *cleanScheduleArray;
@property (nonatomic, retain) LoadPublicTimelineOperation *loadPublicTimelineOperation;

@property (nonatomic, retain) IBOutlet ProgrammeDetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;

-(void)refresh;

@end






