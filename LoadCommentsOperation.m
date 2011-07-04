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

-(void)main
{
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	////////////////////////////////////////////////////////////////
    
    //    NSLog(@"Running LoadCommentsOperation::main with programme ID %d", _programmeID);

    // Set Apple spinner going
	[self setNetworkActivityIndicatorVisible:YES];
	
    // Create URL to retrieve comments from 
    //    NSString *liveURL = [NSString stringWithFormat:@"http://wewatch.co.uk/broadcasts/%d.json", _programmeID];
    //    NSLog(@"Live commentsURL = %@", liveURL);
    
    //    NSURL *commentsURL = [NSURL URLWithString:liveURL];
    NSURL *commentsURL = [NSURL URLWithString:@"http://192.168.1.101/51641.json"];

    // Pull down the JSON data
    NSData *json = [[NSData alloc] initWithContentsOfURL:commentsURL];
	
    // Deserialise into a raw comments array
	NSDictionary *rawCommentsDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:json error:nil];
    
    [json release];
    
    // Parse the raw schedule array into usable form
    NSArray *commentsArray = [self parseRawCommentsWith:rawCommentsDict];
    
    // Run this class's didLoadComments action
   	[self performSelectorOnMainThread:@selector(didLoadComments:) withObject:commentsArray waitUntilDone:YES];
    
    // Hide the Apple spinner
	[self setNetworkActivityIndicatorVisible:NO];	
    
	////////////////////////////////////////////////////////////////	
	[pool drain];
    
}

-(void)dealloc {
    
    [super dealloc];
}

-(NSArray *)parseRawCommentsWith:(NSDictionary *)rawCommentsDict {
    
    //  NSLog(@"Running LoadCommentsOperation::parseRawCommentsWith:");
    
    // Parse the retrieved comments and pass back
    
    // Create a mutable array to contain the comments
    NSArray *parsedCommentsArray;

    // Check if there's anything contained in the intentions key
    if ( [rawCommentsDict objectForKey:@"intentions"] ) {

        // Grab the contents of the intentions key as an array
        parsedCommentsArray = [rawCommentsDict objectForKey:@"intentions"];

    }
    
    return parsedCommentsArray;
    
}


-(void)didLoadComments:(NSArray *)commentsArray
// Method that's fired after the async job runs
{
	if (![self isCancelled])
      {
        // Run the didLoadComments: method in the delegate class (in this case, ProgrammeCommentViewController
        [self.delegate LoadCommentsOperation:self didLoadComments:commentsArray];
        
      }
}

@end