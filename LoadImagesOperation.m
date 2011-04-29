//
//  LoadImagesOperation.m
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "LoadImagesOperation.h"
#import "NSOperation+ActivityIndicator.h"

@implementation LoadImagesOperation

@synthesize delegate;
@synthesize tweet;

-(void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[self setNetworkActivityIndicatorVisible:YES];
	
	// Load the images.
	UIImage *profileImage = [self loadImageForKeyPath:@"user.profile_image_url"];
	UIImage *backgroundImage = [self loadImageForKeyPath:@"user.profile_background_image_url"];

	if (!profileImage)
	{
		profileImage = [UIImage imageNamed:@"profile-image-error.png"];
	}
	
	if (!backgroundImage)
	{
		backgroundImage = [UIImage imageNamed:@"background-image-error.png"];
	}
	
	
	// TODO: Call the delegate method to return the images.
	
	NSArray *images = [[NSArray alloc] initWithObjects:profileImage, backgroundImage, nil];
	
	// Run main thread callback.
	[self performSelectorOnMainThread:@selector(imagesLoaded:) withObject:images waitUntilDone:YES];
	
	[self setNetworkActivityIndicatorVisible:NO];
	
	[self.tweet release];
	[pool drain];
}

#pragma mark -
#pragma mark Private methods.

-(UIImage *)loadImageForKeyPath:(NSString *)keyPath
{
	UIImage *theImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.tweet valueForKeyPath:keyPath]]]];
	return theImage;
}

#pragma mark -
#pragma mark Main thread.

-(void)imagesLoaded:(NSArray *)images
{
	if (![self isCancelled])
	{
		[self.delegate loadImagesOperation:self didLoadProfileImage:[images objectAtIndex:0] andBackgroundImage:[images objectAtIndex:1]];
	}
}










@end
