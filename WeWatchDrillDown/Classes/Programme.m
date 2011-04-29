//
//  Programme.m
//  WeWatchTabled
//
//  Created by Tim Duckett on 15/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "Programme.h"

@implementation Programme

@synthesize programmeID;
@synthesize title;
@synthesize subtitle;
@synthesize channel;
@synthesize time;
@synthesize timeSlot;
@synthesize description;
@synthesize duration;
@synthesize watchers;
@synthesize programmeImage;

// Method to create a random programme object for testing purposes
+(id)randomProgramme {

    // Array of random programme titles
    NSArray *randomTitleList = [NSArray arrayWithObjects: @"Gardeners' World", 
                                @"Monty Don's Italian Gardens", 
                                @"Frank Skinner's Opinionated", 
                                @"The Graham Norton Show", 
                                @"The Review Show", 
                                @"Later... with Jools Holland", 
                                nil];

    // Array of random programme titles
    NSArray *randomSubtitleList = [NSArray arrayWithObjects: @"Gardeners' World", 
                                @"Monty Don's Italian Gardens", 
                                @"Frank Skinner's Opinionated", 
                                @"The Graham Norton Show", 
                                @"The Review Show", 
                                @"Later... with Jools Holland", 
                                nil];
    
    // Array of random blurbs
	NSArray *randomDescriptionList = [NSArray arrayWithObjects: @"Andrew Graham-Dixon uncovers the history of Petworth House, as he learns how to vacuum-clean sculpture, perfectly polish banisters, preserve Capability Brown's immense parkland and buff up Baroque angels in the chapel.",
                                @"Renowned baking writer Mary Berry and professional baker Paul Hollywood explore the history of the Great British wedding cake. They look at its dramatic change through the eras, from the earliest Tudor creation and the extravagant Victorian period, to wartime Britain, the affluent eighties and the present day.",
                               @"Maddy has what she thinks is a neighbourly chat with her neighbour, a lawyer, and finds she has been charged for the pleasure. Meanwhile, Jim discovers he has an ardent admirer.",
                               @"Sugar is thrilled at the prospect of moving in to William's house as governess to his neglected daughter Sophie. But she soon finds Agnes' condition to have deteriorated, worn down by the constant visits from Dr Curlew, and Sugar makes a promise to help her before it is too late.",
                               @"Lucy Worsley, chief curator of the historic royal palaces, focuses on the bathroom - a room that didn't even exist in many British homes until 50 years ago. From the medieval bath houses to London Bridge's communal loos to finding out how piped water got to our homes and finally getting to the bottom of the Crapper myth at Stoke's Toilet Museum, Lucy tracks how our attitude to washing has changed over the centuries and the development of what we think of now as the most essential room in the house.",
                               @"The National Lottery Wednesday Night Draws presented by OJ Borg includes Lotto and Thunderball draws.", 
                                nil];
    
    // Array of random times
    NSArray *randomTimeList = [NSArray arrayWithObjects: @"7pm", @"7:30pm", @"8pm", @"8:30pm", @"9pm", @"10pm", nil];
    
    // Array of random channels
    NSArray *randomChannelList = [NSArray arrayWithObjects: @"BBC Two", @"BBC Two", @"BBC Two", @"BBC One", @"BBC Four", @"BBC Three", nil];
    
    // Array of random durations
    NSArray *randomDurationList = [NSArray arrayWithObjects: @"30min", @"1hr", @"30min", @"45min", @"50min", @"1h30min", nil];
    
    // Array of random programm images
    NSArray *randomImageList = [NSArray arrayWithObjects:@"programme_image1.png",@"programme_image2.png",@"programme_image3.png",@"programme_image4.png",@"programme_image5.png", nil];

    // Generate random timeslot (somewhere between 7 and 10)
    int timeSlot = ( random() % 3 ) + 7;
    
    // Generate random programme id
    int programmeID = ( random() % 20000 );
    
    // Generate random watchers
    int watchers = ( random() % 10 );

	// Build random indexes
    int titleList = random() % [randomTitleList count];
    int subtitleList = random() % [randomSubtitleList count];
    int descriptionList = random() % [randomDescriptionList count];    
    int timeList = random() % [randomTimeList count];
    int channelList = random() % [randomChannelList count];
    int durationList = random() % [randomDurationList count];
    int imageList = random() % [randomImageList count];
    
    // Grab the values to create the
    
    // Build new programme
    Programme *newProgramme = [[self alloc] initWithProgrammeID:programmeID
                                                       andTitle:[randomTitleList objectAtIndex:titleList]
                                                    andSubtitle:[randomTimeList objectAtIndex:subtitleList]
                                                     andChannel:[randomChannelList objectAtIndex:channelList]
                                                        andTime:[randomTimeList objectAtIndex:timeList]
                                                    andTimeslot:timeSlot 
                                                 andDescription:[randomDescriptionList objectAtIndex:descriptionList]
                                                    andDuration:[randomDurationList objectAtIndex:durationList]
                                                    andWatchers:watchers
                                                       andImage:[randomImageList objectAtIndex:imageList]];
	
    NSLog(@"Programme: %@", newProgramme.title);
    
	return newProgramme;
  }

// Create and return a programme with fully-populated attributes
- (id)initWithProgrammeID:(int)iProgrammeID 
                 andTitle:(NSString *)iTitle
              andSubtitle:(NSString *)isubtitle 
               andChannel:(NSString *)iChannel
                  andTime:(NSString *)iTime
              andTimeslot:(int)iTimeSlot 
           andDescription:(NSString *)iDescription
              andDuration:(NSString *)iDuration
              andWatchers:(int)iWatchers
                 andImage:(NSString *)iProgrammeImage
{
	// Call the superclass's designated initializer 
	self = [super init];
	
	// Did the superclass's initialization fail? 
	if (!self)
		return nil;
	
	// Give the instance variables initial values 
    [self setProgrammeID:iProgrammeID];
    [self setTitle:iTitle];
    [self setSubtitle:isubtitle];
    [self setChannel:iChannel];
    [self setTime:iTime];
    [self setTimeSlot:iTimeSlot];
    [self setDescription:iDescription];
    [self setDuration:iDuration];
    [self setWatchers:iWatchers];
    [self setProgrammeImage:iProgrammeImage];
	
	// Return the address of the newly initialized object
	return self;
}

@end
