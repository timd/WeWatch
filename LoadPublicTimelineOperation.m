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
#import "Constants.h"

@implementation LoadPublicTimelineOperation

@synthesize delegate;
@synthesize twitterName;
@synthesize _engine;

-(id)initWithTwitterName:(NSString *)name {
    
    NSLog(@"Running initWithTwitterName: %@", name);
    
    if (![super init]) {
        return nil;
    }
    
    [self setTwitterName: name];
    
    return self;
    
}

#pragma mark -
#pragma mark Retrieval methods

-(void)main
{
    
    NSLog(@"Running data retrieval method from LoadPublicTimelineOperation");
    NSLog(@"Twitter name = %@", [self twitterName]);
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	////////////////////////////////////////////////////////////////
    
	[self setNetworkActivityIndicatorVisible:YES];
	
    // Construct retrieval URL
    NSString *weWatchURL;
    if (KUseLocalDataFeed == 1) {
        weWatchURL = @"http://192.168.1.101/today.json";
    } else {
        weWatchURL = @"http://wewatch.co.uk/today.json";
    }
    
    // If there is a twitter name passed into the method, append this to the end of the URL
    if ([self twitterName]) {
        weWatchURL = [weWatchURL stringByAppendingString:[NSString stringWithFormat:@"?username=%@", [self twitterName]]];
    }

    // NSLog(@"URL = %@", weWatchURL);
    
	NSData *json = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:weWatchURL]];
	
	NSArray *rawScheduleArray = [[CJSONDeserializer deserializer] deserializeAsArray:json error:nil];
    
    [json release];
    
    // Parse the raw schedule array into usable form
    NSArray *scheduleArray = [self parseRawScheduleWith:rawScheduleArray];
    // NSLog(@"cleanScheduleArrray = %@", scheduleArray);

	[self performSelectorOnMainThread:@selector(publicTimelineDidLoad:) withObject:scheduleArray waitUntilDone:YES];
	
	[self setNetworkActivityIndicatorVisible:NO];	
	
	////////////////////////////////////////////////////////////////	
	[pool drain];
    
    NSLog(@"Finished data retrieval method from LoadPublicTimelineOperation");
}

-(NSArray *)parseRawScheduleWith:(NSArray *)rawData {
    
    // Method to take raw schedule from the JSON feed, and convert
    // into clean for for TableView
    //
    // Takes an NSArray of the raw JSON data, and
    // returns an NSArray of clean programme data
    
    NSLog(@"Running parseRawSchedule");
    
    // First, create the timeslot arrays
    NSMutableArray *timeslot6 = [[[NSMutableArray alloc] initWithObjects: nil] autorelease];
    NSMutableArray *timeslot7 = [[[NSMutableArray alloc] initWithObjects: nil] autorelease];
    NSMutableArray *timeslot8 = [[[NSMutableArray alloc] initWithObjects: nil] autorelease];
    NSMutableArray *timeslot9 = [[[NSMutableArray alloc] initWithObjects: nil] autorelease];
    NSMutableArray *timeslot10 = [[[NSMutableArray alloc] initWithObjects: nil] autorelease];
    NSMutableArray *timeslot11 = [[[NSMutableArray alloc] initWithObjects: nil] autorelease];
    
    // Create an array to hold the timeslots that get retrieved
    NSMutableArray *timeslots = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
    
    // Display the tweets that we've got
    // NSLog(@"Raw schedules = %@", rawData);
        
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
            // watcherNames
            // amWatching
            
            // Set programme ID
            NSInteger programmeID = [[currentProgrammesFromJSON objectForKey:@"id"] intValue];
            //NSLog(@"ProgrammeID = %d", programmeID);
            
            // Set title
            NSString *title = [[currentProgrammesFromJSON objectForKey:@"title"] stringByConvertingHTMLToPlainText];
            //NSLog(@"Title = %@", title);
            
            // Set subtitle, checking for potential null value
            
            NSString *subtitle;
            
            if ([currentProgrammesFromJSON objectForKey:@"subtitle"] != nil) {
                // Retrieve the value that's been brought down 
                subtitle = [[currentProgrammesFromJSON objectForKey:@"subtitle"] stringByConvertingHTMLToPlainText];
            } else {
                // The subtitle value is empty, therefore we need to pad it with an empty string
                subtitle = @"";
            }
            //NSLog(@"Subtitle = %@", subtitle);
            
            // Set description
            NSString *description = [[currentProgrammesFromJSON objectForKey:@"description"] stringByConvertingHTMLToPlainText];
            //NSLog(@"Description = %@", description);
            
            // Set channel
            NSDictionary *channelHolder = [currentProgrammesFromJSON objectForKey:@"channel"];
            NSString *channel = [channelHolder objectForKey:@"name"];
            //NSLog(@"Channel = %@", channel);
            
            // Set watcher names, checking for nil values
            NSDictionary *watcherNamesHolder = [currentProgrammesFromJSON objectForKey:@"friends_watching"];
            //NSLog(@"Friends_watching = %@", watcherNamesHolder);
            //NSLog(@"count = %d", [watcherNamesHolder count]);
            
            // iterate across the friends array
            NSMutableArray *localNamesArray = [[NSMutableArray alloc] initWithObjects: nil];
            
            if ( [watcherNamesHolder count] == 0 ) {
                // Nobody's watching this programme
                [localNamesArray addObject:@"None of your friends are currently planning to watch this programme."];
            } else {

                // Iterate across the names and load them into the localNamesArray
                
                for (id nameElement in watcherNamesHolder) {
                    
                    // Clean up format of name so it's in the form @username_””’
                    NSString *cleanedTwitterName = [NSString stringWithFormat:@"@%@ ", [nameElement objectForKey:@"username"]];
                    
                    NSString *name = [nameElement objectForKey:@"username"];
                    //NSString *twitterName = [@"@" stringByAppendingString:name];
                    //NSString *cleanTwitterName = [twitterName stringByAppendingString:@" "];
                    NSLog(@"Username = %@", name);
                    [localNamesArray addObject:cleanedTwitterName];
                }
            }
            
            // Set watch ID
            NSInteger watchingID = 0;
            
            if ([currentProgrammesFromJSON objectForKey:@"watching_id"] != nil) {
                watchingID = [[currentProgrammesFromJSON objectForKey:@"watching_id"] intValue];
                NSLog(@"*** Watching ID = %d", watchingID);
            }
            
            // Set start time & timeslot
            NSString *startTimeFromJSON = [currentProgrammesFromJSON objectForKey:@"start"];
            
            NSInteger timeSlot = [[startTimeFromJSON substringWithRange:NSMakeRange(11, 2)] intValue] - 12;
            
            NSString *startMin = [startTimeFromJSON substringWithRange:NSMakeRange(14, 2)];
            NSString *startTime = [NSString stringWithFormat:@"%@:%@pm",[NSString stringWithFormat:@"%d", timeSlot], startMin]; 
            //NSLog(@"StartTime = %@", startTime);
                        
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
            
            //NSLog(@"Duration = %@", duration);
            
            // Set watchers
            NSInteger watchers = [[currentProgrammesFromJSON objectForKey:@"watchers"] intValue];
            //NSLog(@"Watchers = %d", watchers);
            
            // Set programme image
            NSString *programmeImage;
            programmeImage = nil;
            
            if ( [currentProgrammesFromJSON objectForKey:@"image"] != nil ) {
                
                NSMutableDictionary *imageHolder = [currentProgrammesFromJSON objectForKey:@"image"];
                
                if ( [[imageHolder allKeys] containsObject:@"thumb"] ) {
                    
                    programmeImage = [NSString stringWithFormat:@"http://wewatch.co.uk%@", [imageHolder objectForKey:@"thumb"]];
                    
                }
                
            } else {
                // There's no image url, presumably because it's a C4 programme
                // send back something guaranteed to throw the retrieval process
                programmeImage = @"LOCAL";                        
                
            }
            
            // Set watching status
            NSNumber *val = [currentProgrammesFromJSON objectForKey:@"watching"];
            BOOL amWatching = [val boolValue];
            
            //NSLog(@"amWatchingFlag = %d", amWatching);
            
            // Set programme URL if available
            NSString *programmeURL;
            
            if ([currentProgrammesFromJSON objectForKey:@"link"] != nil) {
                // Retrieve the value that's been brought down 
                programmeURL = [currentProgrammesFromJSON objectForKey:@"link"];
            } else {
                // The subtitle value is empty, therefore we need to pad it with an empty string
                programmeURL = @"";
            }
            
            // Set the film flag
            Boolean isFilm;
            if ([currentProgrammesFromJSON objectForKey:@"channel"] == @"BBC Two") {
                isFilm = YES;
            } else {
                isFilm = NO;
            }
                      
            // Create a Programme object from each NSDictionary
            Programme *tempProgramme = [[Programme alloc] initWithProgrammeID:programmeID 
                                                                     andTitle:title 
                                                                  andSubtitle:subtitle 
                                                                   andChannel:channel 
                                                                      andTime:startTime
                                                                  andFullTime:startTimeFromJSON
                                                                  andTimeslot:timeSlot 
                                                               andDescription:description 
                                                                  andDuration:duration 
                                                                  andWatchers:watchers 
                                                                     andImage:programmeImage
                                                              andWatcherNames:localNamesArray
                                                                andAmWatching:amWatching
                                                                andWatchingID:watchingID
                                                              andProgrammeURL:programmeURL
                                                              andReminderFlag:NO
                                                                    andIsFilm:isFilm];
            
            // Release the local objects we created
            [localNamesArray release];
            
            // Figure out which timeslot we're dealing with, and load the Programme object into the appropriate one
            if (timeSlot == 6) {
                // put the programme object in array 6
                [timeslot6 addObject:tempProgramme];
                
                // Add a timeslot into the timeslots array
                [timeslots addObject:[NSNumber numberWithInt:timeSlot]];
                
            } else if (timeSlot == 7) {
                // put the programme object in array 7
                [timeslot7 addObject:tempProgramme];
                
                // Add a timeslot into the timeslots array
                [timeslots addObject:[NSNumber numberWithInt:timeSlot]];

            } else if (timeSlot == 8) {
                // put the programme object in array 8
                [timeslot8 addObject:tempProgramme];
                
                // Add a timeslot into the timeslots array
                [timeslots addObject:[NSNumber numberWithInt:timeSlot]];

            } else if (timeSlot == 9) {
                // put the programme object in array 9
                [timeslot9 addObject:tempProgramme];
                
                // Add a timeslot into the timeslots array
                [timeslots addObject:[NSNumber numberWithInt:timeSlot]];

            } else if (timeSlot == 10) {
                // must be 10, put the programme object in array 10
                [timeslot10 addObject:tempProgramme];
                
                // Add a timeslot into the timeslots array
                [timeslots addObject:[NSNumber numberWithInt:timeSlot]];

            } else {
                // must be 11, put the programme object in array 11
                [timeslot11 addObject:tempProgramme];
               
                // Add a timeslot into the timeslots array
                [timeslots addObject:[NSNumber numberWithInt:timeSlot]];
                
            }
            
            // Release the tempProgramme object, we don't need it any more
            [tempProgramme release];
            
        }
    
    // Load up the timeslot arrays into the schedule array ready for return
    
    // Create a temporary array of all the timeslot arrays
    NSArray *tempScheduleArray = [[NSMutableArray alloc] initWithObjects:timeslot6, timeslot7, timeslot8, timeslot9, timeslot10, timeslot11, nil];
    NSMutableArray *cleanScheduleArray = [[[NSMutableArray alloc] init] autorelease];
    
    // Step across the tempScheduleArray and check if each one is empty. If it isn't, stuff it into the cleanScheduleArray
    for (NSArray *element in tempScheduleArray) {
        if ( !(element == nil || element.count == 0) ) {
            [cleanScheduleArray addObject:element];
        }
    }
                                  
    NSLog(@"Finished parseSchedules");    
    [tempScheduleArray release];

    // Add the timeslots array into the FIRST element of the cleanScheduleArray
    [cleanScheduleArray insertObject:timeslots atIndex:0];
    
    // Return the schedule array to the calling function
    
    // Cast from NSArray to NSMutableArray
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:cleanScheduleArray];
    return returnArray;

}

-(void)publicTimelineDidLoad:(NSArray *)publicTimeline
{
    
    NSLog(@"LoadPublicTimelineOperation::publicTimelineDidLoad called");
    
	if (![self isCancelled])
	{
		[self.delegate loadPublicTimelineOperation:self publicTimelineDidLoad:publicTimeline];
	}
}

-(void)dealloc {
    [twitterName release];
    twitterName = nil;
    [super dealloc];
}

@end







