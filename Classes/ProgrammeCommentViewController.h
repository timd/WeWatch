//
//  ProgrammeCommentViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 30/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadCommentDelegate.h"

@class LoadCommentsOperation;

@interface ProgrammeCommentViewController : UIViewController <LoadCommentProtocol> {
    
    // UI outlets
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIScrollView *textScroller;
    IBOutlet UIImageView *backgroundImage;
    
    NSString *_programmeTitle;
    
    // ivar to hold comment retrieval object
    LoadCommentsOperation *loadCommentsOperation;
    
}

@property (nonatomic, retain) NSString *programmeTitle;

-(void)fireLoadCommentsJob;

@end
