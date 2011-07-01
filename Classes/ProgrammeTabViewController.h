//
//  ProgrammeTabViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 30/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Programme;
@class SA_OAuthTwitterEngine;
@class ProgrammeDetailViewController;
@class ProgrammeCommentViewController;

@interface ProgrammeTabViewController : UIViewController {
    
    IBOutlet UIButton *watchButton;
    IBOutlet UIButton *detailButton;
    IBOutlet UIButton *commentButton;
    IBOutlet UILabel *watchButtonLabel;
    
    IBOutlet UIImageView *tabBarImage;
    
    IBOutlet UIView *bodyView;
    //Programme *_displayProgramme;
    
    SA_OAuthTwitterEngine *_twitterEngine;
    
    ProgrammeDetailViewController *_programmeDetailVC;
    ProgrammeCommentViewController *_programmeCommentVC;
}

@property (nonatomic, retain) Programme *displayProgramme;
@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;

-(IBAction)swapViews:(id)sender;

@end
