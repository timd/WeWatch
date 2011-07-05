//
//  LoadCommentDelegate.h
//  WeWatch
//
//  Created by Tim Duckett on 04/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadCommentProtocol

@required

-(void)LoadCommentsOperation:(NSOperation *)theProgrammeCommentOperation didLoadComments:(NSArray *)retrievedComments;

@end
