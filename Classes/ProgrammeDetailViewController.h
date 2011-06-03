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

@class LoadProgrammeImageOperation;
@class SA_OAuthTwitterController;
@class Programme;

@interface ProgrammeDetailViewController : UIViewController <SA_OAuthTwitterEngineDelegate, LoadProgrammeImageOperationDelegate> {
    
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
    IBOutlet UIButton *watchButton;

    // ivar to hold the programme object that gets passed into the view controller
    Programme *displayProgramme;
    
    // ivar to hold an instance of the Twitter engine
    SA_OAuthTwitterEngine *twitterEngine;
    
    LoadProgrammeImageOperation *loadProgrammeImageOperation;
    
}

@property (nonatomic, assign) Programme *displayProgramme;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;
@property (nonatomic, retain) LoadProgrammeImageOperation *loadProgrammeImageOperation;

// ivar to hold the programme image (so that it can be passed into the modal view controller)
@property (nonatomic, retain) UIImage *retrievedProgrammeImage;

-(IBAction)watchProgramme;
-(BOOL)reachable;

@end
