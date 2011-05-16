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
#import "Reachability.h"

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

}

@property (nonatomic, retain) NSArray *scheduleArray;
@property (nonatomic, retain) NSArray *cleanScheduleArray;
@property (nonatomic, retain) LoadPublicTimelineOperation *loadPublicTimelineOperation;

@property (nonatomic, retain) IBOutlet ProgrammeDetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;

-(void)refresh;
-(BOOL)sendTweet:(NSString *)tweetText;
-(void)showTwitterUser;
-(void)logIntoTwitter;

-(BOOL)reachable;

@end






