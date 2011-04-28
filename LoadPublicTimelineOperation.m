//
//  LoadPublicTimelineOperation.m
//  DrillDown
//
//  Created by Aral Balkan on 22/07/2010.
//  Copyright 2010 Naklab. All rights reserved.
//

#import "LoadPublicTimelineOperation.h"
#import "CJSONDeserializer.h"
#import "NSOperation+ActivityIndicator.h"

@implementation LoadPublicTimelineOperation

@synthesize delegate;

-(void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	////////////////////////////////////////////////////////////////

	[self setNetworkActivityIndicatorVisible:YES];
	
	NSData *json = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/public_timeline.json"]];
	
	NSArray *tweetsArray = [[CJSONDeserializer deserializer] deserializeAsArray:json error:nil];

	[self performSelectorOnMainThread:@selector(publicTimelineDidLoad:) withObject:tweetsArray waitUntilDone:YES];
	
	[self setNetworkActivityIndicatorVisible:NO];	
	
	////////////////////////////////////////////////////////////////	
	[pool drain];
}

-(void)publicTimelineDidLoad:(NSArray *)publicTimeline
{
	if (![self isCancelled])
	{
		[self.delegate loadPublicTimelineOperation:self publicTimelineDidLoad:publicTimeline];
	}
}
@end







