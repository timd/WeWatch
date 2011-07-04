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

@interface ProgrammeCommentViewController : UIViewController {
    
    // UI outlets
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIScrollView *textScroller;
    IBOutlet UIImageView *backgroundImage;
    
    NSString *_programmeTitle;
    int _programmeID;
    
    // ivar to hold comment retrieval object
    LoadCommentsOperation *loadCommentsOperation;
    
    // ivar to hold the array of comments
    NSArray *_commentsArray;
    
}

@property (nonatomic, retain) NSString *programmeTitle;
@property (nonatomic) int programmeID;
@property (nonatomic, retain) NSArray *commentsArray;

@end
