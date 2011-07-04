//
//  LoadComments.h
//  WeWatch
//
//  Created by Tim Duckett on 04/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIHTTPRequestDelegate.h"
#import "LoadCommentDelegate.h"

@interface LoadComments : NSOperation <ASIHTTPRequestDelegate> {
    
    id <LoadCommentProtocol> delegate;
    
    NSArray *_commentsArray;
}

@property (nonatomic, retain) NSArray *commentsArray;
@property (nonatomic, assign) id <LoadCommentProtocol> delegate;

-(NSArray *)downloadProgrammeComments:(NSString *)programmeID;



@end
