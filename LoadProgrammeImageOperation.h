//
//  LoadProgrammeImageOperation.h
//  WeWatch
//
//  Created by Tim Duckett on 09/05/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadProgrammeImageOperationDelegate.h"

@interface LoadProgrammeImageOperation : NSOperation {
    
    id <LoadProgrammeImageOperationDelegate> delegate;

    // ivar to hold programme image url passed in from calling methods
    NSURL *programmeImageURL;
    
    // ivar to hold programme image
    UIImage *programmeImage;
    
}

@property (nonatomic, assign) id <LoadProgrammeImageOperationDelegate> delegate;
@property (retain) NSURL *programmeImageURL;
@property (nonatomic, retain) UIImage *programmeImage;

-(id)initWithProgrammeImageURL:(NSURL *)imageURL;

@end
