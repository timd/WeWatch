//
//  ProgrammeDetailViewController.h
//  WeWatchTabled
//
//  Created by Tim Duckett on 15/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "Reachability.h"
#import "LoadProgrammeImageOperationDelegate.h"
#import "PullRefreshTableViewController.h"
#import "WatchModalViewController.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import "Reachable.h"
#import "ASIHTTPRequest.h"

@class LoadProgrammeImageOperation;
@class SA_OAuthTwitterController;
@class Programme;

@interface ProgrammeDetailViewController : UIViewController <SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate, LoadProgrammeImageOperationDelegate, ASIHTTPRequestDelegate> {
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *channelLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *watchersLabel;
    IBOutlet UIImageView *programmeImage;
    IBOutlet UILabel *watchersNamesLabel;
    IBOutlet UIImageView *watchingFlag;
    IBOutlet UILabel *watchButtonLabel;

    // ivar to hold the programme object that gets passed into the view controller
    Programme *displayProgramme;
    
    // ivar to hold an instance of the Twitter engine
    SA_OAuthTwitterEngine *twitterEngine;
    
    LoadProgrammeImageOperation *loadProgrammeImageOperation;
    
    // ivar to hold flag to force data reload
    BOOL forceDataReload;
    
    // ivar to hold the ASIHTTPRequest object
    ASIHTTPRequest *requestMade;
    
}

@property (nonatomic, assign) Programme *displayProgramme;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;
@property (nonatomic, retain) LoadProgrammeImageOperation *loadProgrammeImageOperation;
@property (nonatomic) BOOL forceDataReload;

// ivar to hold the programme image (so that it can be passed into the modal view controller)
@property (nonatomic, retain) UIImage *retrievedProgrammeImage;

extern NSString * const didUnwatchProgrammeNotification;

-(IBAction)watchProgramme;
-(void)flipModalWatchPage;

-(void)showModalWatchPage;

// Notification methods
-(void)didReceiveWatchProgrammeMessage;
-(void)didReceiveUnwatchProgrammeMessage;

-(void)dismissCurrentView;
-(void)alterWatchersNumberBy:(int)incValue;

@end
