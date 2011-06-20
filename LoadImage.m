//
//  LoadImage.m
//  WeWatch
//
//  Created by Tim Duckett on 20/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "LoadImage.h"
#import "NSOperation+ActivityIndicator.h"


@implementation LoadImage

@synthesize programmeImageURL;
@synthesize delegate;

#pragma mark -
#pragma mark Class instance methods

-(id)initWithProgrammeImageURL:(NSURL *)imageURL {
    if (![super init]) {
        return nil;
    }

    self.programmeImageURL = imageURL;
    
    return self;
    
}

-(void)main
{
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	////////////////////////////////////////////////////////////////
    
	[self performSelectorOnMainThread:@selector(downloadProgrammeImage:) withObject:[self programmeImageURL] waitUntilDone:YES];
    
	////////////////////////////////////////////////////////////////	
	[pool drain];
    
}

#pragma mark -
#pragma mark Custom methods

-(void)downloadProgrammeImage:(NSURL *)imageURL {
    
   	[self setNetworkActivityIndicatorVisible:YES];
    
    // Fire query at API
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageURL];
    [request setDelegate:self];
    
    // Switch on caching
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    
    // Fire off request using ASIHTTPRequest's asynchronicity
    [request startAsynchronous];
    
}

#pragma mark -
#pragma mark ASIHTTPRequest Delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request {
    
   	[self setNetworkActivityIndicatorVisible:NO];	

    // Request was successful, handle the data that was returned
    NSData *responseData = [request responseData];
    
    // Create an image from the response data
    UIImage *retrievedImage = [UIImage imageWithData:responseData];
    
    // Check if the cached image was used
    if ([request didUseCachedResponse] ) {
        NSLog(@"DID use cache");
    } else {
        NSLog(@"Didn't use cache");
    }
    
    // Call the delegate's didLoadImage method so it can respond to the image we've grabbed
    [self.delegate didLoadImage:retrievedImage];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    // Request didn't work
    NSError *error = [request error];
    NSLog(@"Image retrieval failed with errror: %@", &error);
    
    // Return a placeholder image
    [self.delegate didLoadImage:[UIImage imageWithContentsOfFile:@"wewatch.png"]];
}

@end
