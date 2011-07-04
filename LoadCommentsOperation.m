//
//  LoadComments.m
//  WeWatch
//
//  Created by Tim Duckett on 04/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "LoadCommentsOperation.h"
#import "LoadCommentDelegate.h"
#import "NSOperation+ActivityIndicator.h"
#import "CJSONDeserializer.h"

@implementation LoadCommentsOperation

@synthesize delegate;
@synthesize programmeID = _programmeID;
@synthesize commentsArray = _commentsArray;

#pragma mark -
#pragma mark Retrieval methods

-(id)init {
    
    if (![super init]) {
        return nil;
    }
    
    return self;
}

-(id)initWithProgrammeID:(int)programmeID {

    if (![super init]) {
        return nil;
    }
    
    self.programmeID = programmeID;
    
    return self;
    
}

-(void)main
{
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	////////////////////////////////////////////////////////////////
    
	[self setNetworkActivityIndicatorVisible:YES];
	
    // Retrieve NSImage containing the programme image
    
    // Create URL to retrieve comments from 
    NSURL *commentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://wewatch.co.uk/broadcasts/%d.json", _programmeID]];
    
    NSData *json = [[NSData alloc] initWithContentsOfURL:commentsURL];
	
	NSArray *rawCommentsArray = [[CJSONDeserializer deserializer] deserializeAsArray:json error:nil];
    
    [json release];
    
    // Parse the raw schedule array into usable form
    NSArray *commentsArray = [self parseRawCommentsWith:rawCommentsArray];
    
   	[self performSelectorOnMainThread:@selector(didLoadComments:) withObject:commentsArray waitUntilDone:YES];
    
	[self setNetworkActivityIndicatorVisible:NO];	

	NSLog(@"Finished running LoadCommentsOperation::main");
    
	////////////////////////////////////////////////////////////////	
	[pool drain];
    
}

-(void)dealloc {
    
    [super dealloc];
}

-(NSArray *)parseRawCommentsWith:(NSArray *)rawCommentsArray {
    
    // Parse the retrieved comments and pass back
    
    NSArray *parsedCommentsArray = [NSArray arrayWithObjects:@"comment1", @"comment2", @"comment3", nil];
    
    return parsedCommentsArray;
    
}

-(void)didLoadComments:(NSArray *)commentsArray
{
	if (![self isCancelled])
      {
        NSLog(@"Running LoadCommentsOperation::didLoadComments");
        
        [self.delegate LoadCommentsOperation:self didLoadComments:commentsArray];
        
      }
}


@end
