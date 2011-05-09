//
//  LoadProgrammeImageOperation.m
//  WeWatch
//
//  Created by Tim Duckett on 09/05/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "LoadProgrammeImageOperation.h"
#import "NSOperation+ActivityIndicator.h"

@implementation LoadProgrammeImageOperation

@synthesize delegate;
@synthesize programmeImageURL;
@synthesize programmeImage;

#pragma mark -
#pragma mark Retrieval methods

-(id)init {
    
    if (![super init]) {
        return nil;
    }
    
    return self;
}

-(void)main
{
    
    NSLog(@"Running data retrieval method from LoadPublicImageOperation");
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	////////////////////////////////////////////////////////////////
    
	[self setNetworkActivityIndicatorVisible:YES];
	
    // Retrieve NSImage containing the programme image
    
    UIImage *retrievedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:programmeImageURL]];
        
	[self performSelectorOnMainThread:@selector(programmeImageRetrievalDidLoad:) withObject:retrievedImage waitUntilDone:YES];
	
	[self setNetworkActivityIndicatorVisible:NO];	
	
	////////////////////////////////////////////////////////////////	
	[pool drain];
    
    NSLog(@"Finished data retrieval method from LoadPublicImageOperation");
}

-(void)programmeImageRetrievalDidLoad:(NSArray *)publicTimeline
{
	if (![self isCancelled])
      {
        //		[self.delegate loadPublicTimelineOperation:self publicTimelineDidLoad:publicTimeline];
      }
}
-(void)dealloc {
    [programmeImageURL release];
    programmeImageURL = nil;
    [programmeImage release];
    programmeImage = nil;
    [super dealloc];
}



@end
