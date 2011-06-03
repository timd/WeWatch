//
//  WatchModalViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 03/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Programme.h"

@class Programme;

@interface WatchModalViewController : UIViewController <UITextViewDelegate> {
 
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *channelLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UIImageView *programmeImage;
    IBOutlet UIImageView *watchingFlag;
    IBOutlet UITextView *tweetText;
    
    // ivar to hold the programme object that gets passed into the view controller
    Programme *displayProgramme;
    
}

@property (nonatomic, retain) Programme *displayProgramme;
@property (nonatomic, retain) UIImage *providedProgrammeImage;

-(IBAction)dismissView;
-(IBAction)resignTextViewFirstResponder;
-(IBAction)watchProgramme;

@end
