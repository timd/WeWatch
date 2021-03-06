//
//  WatchModalViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 03/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Programme.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import "MGTwitterEngine.h"
#import "ASIHTTPRequest.h"


@class Programme;

@interface WatchModalViewController : UIViewController <UITextViewDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate, ASIHTTPRequestDelegate> {
 
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *channelLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UIImageView *programmeImage;
    IBOutlet UITextView *tweetText;
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UISwitch *tweetSwitch;
    IBOutlet UILabel *textCount;
    IBOutlet UIImageView *channelLogo;
    
    // ivar to hold the programme object that gets passed into the view controller
    Programme *displayProgramme;
    
    // ivar to hold Twitter engine passed in from ProgrammeDetailViewController
    SA_OAuthTwitterEngine *twitterEngine;
    
    // ivar to hold Twitter username
    NSString *twitterUser;
    
    // ivars to hold tweet and schedule state
    BOOL tweetState;
    BOOL remindState;
    
    // ivar to hold background text
    UILabel *backgroundText;

}

@property (nonatomic, retain) Programme *displayProgramme;
@property (nonatomic, retain) UIImage *providedProgrammeImage;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;
@property (nonatomic, retain) NSString *twitterUser;

extern NSString * const didWatchProgrammeNotification;

-(IBAction)dismissView;
-(IBAction)resignTextViewFirstResponder;
-(IBAction)watchProgramme;

@end
