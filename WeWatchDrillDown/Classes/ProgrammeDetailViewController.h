//
//  ProgrammeDetailViewController.h
//  WeWatchTabled
//
//  Created by Tim Duckett on 15/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

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
    
    Programme *displayProgramme;
    
}

@property (nonatomic, assign) Programme *displayProgramme;

@end
