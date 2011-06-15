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
@synthesize fullTime;
@synthesize timeSlot;
@synthesize description;
@synthesize duration;
@synthesize watchers;
@synthesize programmeImage;
@synthesize watcherNames;
@synthesize amWatching;
@synthesize watchingID;
@synthesize reminderFlag;

// Create and return a programme with fully-populated attributes
- (id)initWithProgrammeID:(int)iProgrammeID 
                 andTitle:(NSString *)iTitle
              andSubtitle:(NSString *)isubtitle 
               andChannel:(NSString *)iChannel
                  andTime:(NSString *)iTime
              andFullTime:(NSString *)iFullTime
              andTimeslot:(int)iTimeSlot 
           andDescription:(NSString *)iDescription
              andDuration:(NSString *)iDuration
              andWatchers:(int)iWatchers
                 andImage:(NSString *)iProgrammeImage
          andWatcherNames:(NSArray *)iWatcherNames
            andAmWatching:(Boolean)iAmWatching
            andWatchingID:(int)iWatchingID
          andReminderFlag:(Boolean)iReminderFlag
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
    [self setFullTime:iFullTime];
    [self setTimeSlot:iTimeSlot];
    [self setDescription:iDescription];
    [self setDuration:iDuration];
    [self setWatchers:iWatchers];
    [self setProgrammeImage:iProgrammeImage];
    [self setWatcherNames:iWatcherNames];
    [self setAmWatching:iAmWatching];
    [self setWatchingID:iWatchingID];
    [self setReminderFlag:iReminderFlag];
	
	// Return the address of the newly initialized object
	return self;
}

@end
