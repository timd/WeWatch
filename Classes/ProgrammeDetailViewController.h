//
//  ProgrammeDetailViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 01/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Programme.h"
#import "LoadImageDelegate.h"

@class LoadImage;

@interface ProgrammeDetailViewController : UIViewController <LoadImageDelegate> {
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *channelLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *watchersLabel;
    IBOutlet UILabel *watchersNamesLabel;
    IBOutlet UIImageView *watchingFlag;
    IBOutlet UIImageView *channelIcon;
    IBOutlet UIButton *reminderButton;
    IBOutlet UIButton *webButton;
    IBOutlet UILabel *commentCountLabel;
    
    // ivar to hold the programme object that gets passed into the view controller
    Programme *_displayProgramme;
    
    // ivar to hold the programme image
    UIImage *_programmeImage;
    
    // ivar to hold a reference to the image load operation
    LoadImage *_loadImageOperation;

}

@property (nonatomic, retain) Programme *displayProgramme;

-(void)retrieveImageAsynchronously;
    
// Image retrieval delegate methods
-(void)didLoadImage:(UIImage *)retrievedImage;
-(UIImage*)imageWithBorderFromImage:(UIImage*)source;

@end
