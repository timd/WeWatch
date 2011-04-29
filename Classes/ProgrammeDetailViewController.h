//
//  ProgrammeDetailViewController.h
//  WeWatchTabled
//
//  Created by Tim Duckett on 15/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"

@class SA_OAuthTwitterController;
@class Programme;

@interface ProgrammeDetailViewController : UIViewController {
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *channelLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *watchersLabel;
    IBOutlet UIImageView *programmeImage;

    // ivar to hold the programme object that gets passed into the view controller
    Programme *displayProgramme;
    
    // ivar to hold a test variable
    NSString *testString;
    
    // ivar to hold an instance of the Twitter engine
    SA_OAuthTwitterEngine *twitterEngine;
    
}

@property (nonatomic, assign) Programme *displayProgramme;
@property (nonatomic, retain) NSString *testString;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;

-(IBAction)watchProgramme;

@end
