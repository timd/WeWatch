//
//  LoadImage.h
//  WeWatch
//
//  Created by Tim Duckett on 20/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIHTTPRequestDelegate.h"
#import "LoadImageDelegate.h"


@interface LoadImage : NSOperation <ASIHTTPRequestDelegate> {
    
    id <LoadImageDelegate> delegate;
    
    NSURL *programmeImageURL;
    
    UIImage *programmeImage;
    
}

@property (nonatomic, retain) NSURL *programmeImageURL;
@property (nonatomic, assign) id <LoadImageDelegate> delegate;

-(id)initWithProgrammeImageURL:(NSURL *)imageURL;
-(void)downloadProgrammeImage:(NSURL *)imageURL;



@end
