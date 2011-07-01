//
//  ProgrammeTabViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 30/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "ASIHTTPRequest.h"

#import "SA_OAuthTwitterEngine.h"
#import "Reachability.h"
#import "PullRefreshTableViewController.h"
#import "WatchModalViewController.h"
#import "SA_OAuthTwitterController.h"
#import "Reachable.h"

@class Programme;
@class SA_OAuthTwitterEngine;
@class ProgrammeDetailViewController;
@class ProgrammeCommentViewController;

@interface ProgrammeTabViewController : UIViewController <SA_OAuthTwitterControllerDelegate, ASIHTTPRequestDelegate> {
    
    IBOutlet UIButton *watchButton;
    IBOutlet UIButton *detailButton;
    IBOutlet UIButton *commentButton;
    IBOutlet UILabel *watchButtonLabel;
    
    IBOutlet UIImageView *tabBarImage;
    
    IBOutlet UIView *bodyView;
    //Programme *_displayProgramme;
    
    // ivar to hold the ASIHTTPRequest object
    ASIHTTPRequest *_requestMade;
    
    // ivar to hold the activity view
    UIActivityIndicatorView *_spinner;
    
    SA_OAuthTwitterEngine *_twitterEngine;
    
    ProgrammeDetailViewController *_programmeDetailVC;
    ProgrammeCommentViewController *_programmeCommentVC;
}

@property (nonatomic, retain) Programme *displayProgramme;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;

-(IBAction)swapViews:(id)sender;

-(void)showModalWatchPage;
-(IBAction)watchProgramme;

-(IBAction)killReminder;

@end
