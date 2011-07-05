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

@interface LoadCommentsOperation : NSOperation <ASIHTTPRequestDelegate> {
    
    id <LoadCommentProtocol> delegate;
    
    // ivar to hold programme id passed in from calling method
    int _programmeID;
    
    // ivar to hold comments array
    NSArray *_commentsArray;
    
}

@property (nonatomic, assign) id <LoadCommentProtocol> delegate;

@property (nonatomic) int programmeID;
@property (nonatomic, retain) NSArray *commentsArray;

-(NSArray *)parseRawCommentsWith:(NSDictionary *)rawCommentsDict;

@end
