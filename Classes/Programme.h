//
//  Programme.h
//  WeWatchTabled
//
//  Created by Tim Duckett on 15/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

//
//  Class for Programme object

#import <Foundation/Foundation.h>


@interface Programme : NSObject {
    
    int programmeID;            // Programme id
    NSString *title;            // Programme title, e.g. Lambing Live
    NSString *subtitle;         // Programme subtitle, if available (blank if not)
    NSString *channel;          // Broadcast channel, e.g. BBC1
    NSString *time;             // Tx time e.g. 1400
    NSString *fullTime;         // Full tx time string
    int timeSlot;               // The timeslot for the programme (7, 8, 9 or 10)
    NSString *description;            // Programme blurb, e.g.g "Ooh! Ickle pretty lambs!"
    NSString *duration;         // Programme duration in minutes e.g. 90
    int watchers;               // Current number of watchers e.g. 10
    NSString *programmeImage;   // Programme image filename
    NSArray *watcherNames;     // Array of Twitter contacts who are watching this programme
    Boolean amWatching;        // Flag to indicate I'm watching the programme
    int watchingID;             // ID of watching flag
    Boolean reminderFlag;          // Flag to indicate that there's a reminder set
    NSString *programmeURL;     // broadcast site URL
    Boolean isFilm;                 // flag for film
}

@property (nonatomic) int programmeID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *fullTime;
@property (nonatomic) int timeSlot;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic) int watchers;
@property (nonatomic, copy) NSString *programmeImage;
@property (nonatomic, copy) NSArray *watcherNames;
@property (nonatomic) Boolean amWatching;
@property (nonatomic) int watchingID;
@property (nonatomic) Boolean reminderFlag;
@property (nonatomic, retain) NSString *programmeURL;
@property (nonatomic) Boolean isFilm;

- (id)initWithProgrammeID:(int)programmeID
                 andTitle:(NSString *)iTitle
              andSubtitle:(NSString *)subtitle
               andChannel:(NSString *)iChannel
                  andTime:(NSString *)iTime
              andFullTime:(NSString *)iFullTime
              andTimeslot:(int)iTimeSlot
           andDescription:(NSString *)iDescription
              andDuration:(NSString *)iDuration
              andWatchers:(int)iWatchers
                 andImage:(NSString *)programmeImage
          andWatcherNames:(NSArray *)watcherNames
            andAmWatching:(Boolean)iAmWatching
            andWatchingID:(int)watchingID
          andProgrammeURL:(NSString *)programmeURL
          andReminderFlag:(Boolean)reminderFlag
                andIsFilm:(Boolean)isFilm;

@end
