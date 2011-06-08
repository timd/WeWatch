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
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import <RestKit/RestKit.h>
#import "Reachable.h"

@class LoadPublicTimelineOperation;
@class ProgrammeDetailViewController;
@class SA_OAuthTwitterController;

@interface RootViewController : PullRefreshTableViewController <LoadPublicTimelineOperationDelegate, SA_OAuthTwitterControllerDelegate, UIAlertViewDelegate> {
	
	LoadPublicTimelineOperation *loadPublicTimelineOperation;
    
    // ivar to hold reference to an ProgrammeDetailViewController
    ProgrammeDetailViewController *programmeDetailViewController;
    
    // ivar to hold reference to a custom cell
    UITableViewCell *nibLoadedCell;
    
    // ivar to hold reference to Twitter OAuth engine
    SA_OAuthTwitterEngine *_engine;
    
    // ivar to hold flag to force data reload
    BOOL forceDataReload;
    
}

@property (nonatomic, retain) NSArray *scheduleArray;
@property (nonatomic, retain) NSArray *cleanScheduleArray;
@property (nonatomic, retain) LoadPublicTimelineOperation *loadPublicTimelineOperation;

@property (nonatomic, retain) IBOutlet ProgrammeDetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;
@property (nonatomic) BOOL forceDataReload;

-(void)refresh;
-(BOOL)sendTweet:(NSString *)tweetText;
-(void)displaySettingsModalWindow;

-(void)didReceiveWatchProgrammeMessage;
-(void)didReceiveUnwatchProgrammeMessage;

// Throbber methods
- (IBAction)showThrobber;
- (IBAction)showThrobberWithStatus;
- (IBAction)dismissThrobber;
- (IBAction)dismissThrobberWithSuccess;
- (IBAction)dismissThrobberWithError;



@end






