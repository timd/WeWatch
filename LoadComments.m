//
//  LoadComments.m
//  WeWatch
//
//  Created by Tim Duckett on 04/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "LoadComments.h"


@implementation LoadComments

@synthesize commentsArray = _commentsArray;
@synthesize delegate;

-(NSArray *)downloadProgrammeComments:(NSString *)programmeID{

    NSArray *commentsArray = [[[NSArray alloc] initWithObjects:@"comment1", @"comment2", nil] autorelease];
    
    return commentsArray;
}

@end
