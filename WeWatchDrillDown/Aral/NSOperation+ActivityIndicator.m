//
//  NSOperation+ActivityIndicator.m
//  Evolutio
//
//  Created by Tim Duckett on 07/09/2009.
//  Copyright 2009 Naklab. All rights reserved.
//

#import "NSOperation+ActivityIndicator.h"

@implementation NSOperation(ActivityIndicator)

#pragma mark -
#pragma mark Network progress

-(void)setNetworkActivityIndicatorVisible:(BOOL)state
{
	NSDictionary *kvcDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:state], @"networkActivityIndicatorVisible", nil];
	
	[[UIApplication sharedApplication] performSelectorOnMainThread:@selector(setValuesForKeysWithDictionary:) 
														withObject: kvcDictionary
													 waitUntilDone:[NSThread isMainThread]];
}

@end
