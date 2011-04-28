//
//  LoadPublicTimelineOperation.m
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "LoadPublicTimelineOperation.h"
#import "CJSONDeserializer.h"
#import "NSOperation+ActivityIndicator.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"
#import "Programme.h"

@implementation LoadPublicTimelineOperation

@synthesize delegate;

-(void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	////////////////////////////////////////////////////////////////

	[self setNetworkActivityIndicatorVisible:YES];
	
	NSData *json = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://wewatch.co.uk/today.json"]];
	
	NSArray *rawScheduleArray = [[CJSONDeserializer deserializer] deserializeAsArray:json error:nil];
    
    // Parse the raw schedule array into usable form
    NSArray *tweetsArray = [self parseRawScheduleWith:rawScheduleArray];
    NSLog(@"cleanScheduleArrray = %@", tweetsArray);

	[self performSelectorOnMainThread:@selector(publicTimelineDidLoad:) withObject:tweetsArray waitUntilDone:YES];
	
	[self setNetworkActivityIndicatorVisible:NO];	
	
	////////////////////////////////////////////////////////////////	
	[pool drain];
}

-(NSArray *)parseRawScheduleWith:(NSArray *)rawData {
    
    // Method to take raw schedule from the JSON feed, and convert
    // into clean for for TableView
    //
    // Takes an NSArray of the raw JSON data, and
    // returns an NSArray of clean programme data
    
    NSLog(@"Running parseRawSchedule");
    
    // First, create the timeslot arrays
    NSMutableArray *timeslot7 = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray *timeslot8 = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray *timeslot9 = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray *timeslot10 = [[NSMutableArray alloc] initWithObjects: nil];
    
    // Display the tweets that we've got
    NSLog(@"Raw schedules = %@", rawData);
        
        // Create the programme objects from the array
        
        
        // Iterate across the array
        for (id arrayElement in rawData) {
            
            // Convert each array element into an NSDictionary
            NSDictionary *currentProgrammesFromJSON = arrayElement;
            
            // Extract the programme attributes from the NSDictionary
            //
            // programmeID
            // Title
            // Subtitle
            // Description
            // Channel
            // Duration
            // Start
            // watchers
            // timeslot
            // programmeImage
            
            // Set programme ID
            NSInteger programmeID = [[currentProgrammesFromJSON objectForKey:@"id"] intValue];
            // NSLog(@"ProgrammeID = %d", programmeID);
            
            // Set title
            NSString *title = [[currentProgrammesFromJSON objectForKey:@"title"] stringByConvertingHTMLToPlainText];
            NSLog(@"Title = %@", title);
            
            // Set subtitle, checking for potential null value
            
            NSString *subtitle;
            
            if ([currentProgrammesFromJSON objectForKey:@"subtitle"] != nil) {
                // Retrieve the value that's been brought down 
                subtitle = [[currentProgrammesFromJSON objectForKey:@"subtitle"] stringByConvertingHTMLToPlainText];
            } else {
                // The subtitle value is empty, therefore we need to pad it with an empty string
                subtitle = @"";
            }
            NSLog(@"Subtitle = %@", subtitle);
            
            // Set description
            NSString *description = [[currentProgrammesFromJSON objectForKey:@"description"] stringByConvertingHTMLToPlainText];
            NSLog(@"Description = %@", description);
            
            // Set channel
            NSDictionary *channelHolder = [currentProgrammesFromJSON objectForKey:@"channel"];
            NSString *channel = [channelHolder objectForKey:@"name"];
            NSLog(@"Channel = %@", channel);
            
            // Set start time & timeslot
            NSString *startTimeFromJSON = [currentProgrammesFromJSON objectForKey:@"start"];
            
            NSInteger timeSlot = [[startTimeFromJSON substringWithRange:NSMakeRange(11, 2)] intValue] - 12;
            NSLog(@"Timeslot = %d", timeSlot);
            
            NSString *startMin = [startTimeFromJSON substringWithRange:NSMakeRange(14, 2)];
            NSString *startTime = [NSString stringWithFormat:@"%@:%@pm",[NSString stringWithFormat:@"%d", timeSlot], startMin]; 
            NSLog(@"StartTime = %@", startTime);
                        
            // Set duration
            NSInteger durationInMins = [[currentProgrammesFromJSON objectForKey:@"duration"] intValue] / 60;

            NSString *duration;
            
            if (durationInMins > 60) {
                NSInteger modulus = durationInMins % 60;
                NSInteger hours = durationInMins / 60;
                
                duration = [NSString stringWithFormat:@"%dh %dm", hours, modulus];
                
            } else {
                duration = [NSString stringWithFormat:@"%d mins", durationInMins];
            }
            
            NSLog(@"Duration = %@", duration);
            
            // Set watchers
            NSInteger watchers = [[currentProgrammesFromJSON objectForKey:@"watchers"] intValue];
            NSLog(@"Watchers = %d", watchers);
            
            // Set programme image
            NSString *programmeImage;
            programmeImage = nil;
            
            if ( [currentProgrammesFromJSON objectForKey:@"image"] != nil ) {
                
                NSMutableDictionary *imageHolder = [currentProgrammesFromJSON objectForKey:@"image"];
                
                if ( [[imageHolder allKeys] containsObject:@"thumb"] ) {
                    
                    programmeImage = [NSString stringWithFormat:@"http://wewatch.co.uk%@", [imageHolder objectForKey:@"thumb"]];
                    NSLog(@"Prog image = %@", programmeImage);
                    
                }
                
            } else {
                
                programmeImage = @"http://www.adoptioncurve.net/wewatch.png";                        
                NSLog(@"Prog image = %@", programmeImage);
                
            }
            
            // Create a Programme object from each NSDictionary
            Programme *tempProgramme = [[Programme alloc] initWithProgrammeID:programmeID 
                                                                     andTitle:title 
                                                                  andSubtitle:subtitle 
                                                                   andChannel:channel 
                                                                      andTime:startTime 
                                                                  andTimeslot:timeSlot 
                                                               andDescription:description 
                                                                  andDuration:duration 
                                                                  andWatchers:watchers 
                                                                     andImage:programmeImage];
            
            // Figure out which timeslot we're dealing with, and load the Programme object into the appropriate one
            if (timeSlot == 7) {
                // put the programme object in array 7
                [timeslot7 addObject:tempProgramme];
            } else if (timeSlot == 8) {
                // put the programme object in array 8
                [timeslot8 addObject:tempProgramme];
            } else if (timeSlot == 9) {
                // put the programme object in array 9
                [timeslot9 addObject:tempProgramme];
            } else {
                // must be 10, put the programme object in array 10
                [timeslot10 addObject:tempProgramme];
            }
            
            // Release the tempProgramme object, we don't need it any more
            [tempProgramme release];
            
        }
    
    // Load up the timeslot arrays into the schedule array ready for return
    NSArray *cleanScheduleArray = [[[NSMutableArray alloc] initWithObjects:timeslot7, timeslot8, timeslot9, timeslot10, nil] autorelease];
    
    NSLog(@"Finished parseSchedules");    

    // Return the schedule array to the calling function
    return cleanScheduleArray;

}

-(void)publicTimelineDidLoad:(NSArray *)publicTimeline
{
	if (![self isCancelled])
	{
		[self.delegate loadPublicTimelineOperation:self publicTimelineDidLoad:publicTimeline];
	}
}
@end







