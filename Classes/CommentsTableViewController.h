//
//  CommentsTableViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 04/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommentsTableViewController : UITableViewController {
    
    // iVar to hold the array of comments
    NSArray *_commentsArray;
    
    // ivar to hold reference to a custom cell
    UITableViewCell *nibLoadedCell;
    
}

@property (nonatomic, retain) NSArray *commentsArray;

-(CGSize)heightForLabelWithText:(NSString *)labelText andFont:(UIFont *)theFont;

- (NSString *)spacePaddedStringForUsername:(NSString *)username andComment:(NSString *)theComment;

@end
