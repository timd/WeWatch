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
@class ProgrammeDetailViewController;

@interface RootViewController : UITableViewController <LoadPublicTimelineOperationDelegate> {
	
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


@end






