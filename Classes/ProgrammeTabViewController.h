//
//  ProgrammeTabViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 30/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"
#import "LoadCommentDelegate.h"

@class SA_OAuthTwitterEngine;
@class ASIHTTPRequest;

@class ProgrammeDetailViewController;
@class ProgrammeCommentViewController;

@class LoadCommentsOperation;

@interface ProgrammeTabViewController : UIViewController <SA_OAuthTwitterControllerDelegate, ASIHTTPRequestDelegate, LoadCommentProtocol> {
    
    IBOutlet UIButton *watchButton;
    IBOutlet UIButton *detailButton;
    IBOutlet UIButton *commentButton;
    IBOutlet UILabel *watchButtonLabel;
    IBOutlet UILabel *commentCount;
    
    IBOutlet UIImageView *tabBarImage;
    
    IBOutlet UIView *bodyView;
    //Programme *_displayProgramme;
    
    // ivar to hold the ASIHTTPRequest object
    ASIHTTPRequest *_requestMade;
    
    // ivar to hold an unwatched flag
    BOOL unwatched;
    
    // ivar to hold the activity view
    UIActivityIndicatorView *_spinner;
    
    SA_OAuthTwitterEngine *_twitterEngine;
    
    ProgrammeDetailViewController *_programmeDetailVC;
    ProgrammeCommentViewController *_programmeCommentVC;
    
    // ivar to hold comment retrieval object
    LoadCommentsOperation *loadCommentsOperation;
    int _programmeID;
    NSArray *_commentsArray;

}

@property (nonatomic, retain) Programme *displayProgramme;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;

-(IBAction)swapViews:(id)sender;

-(void)showModalWatchPage;
-(IBAction)watchProgramme;

-(IBAction)killReminder;

// Notification methods
-(void)didReceiveWatchProgrammeMessage;
-(void)didReceiveUnwatchProgrammeMessage;

// Comment retrieval delegate method
-(void)fireLoadCommentsJob;

@end
