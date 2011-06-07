//
//  WatchModalViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 03/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "WatchModalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachable.h"

@implementation WatchModalViewController

@synthesize displayProgramme;
@synthesize providedProgrammeImage;
@synthesize twitterEngine;
@synthesize twitterUser;

#pragma mark -
#pragma mark Notification methods

/**
 * Timezones are returned to us in the format +nn:nn
 * The date formatter currently does not support IS 8601 dates, so
 * we convert timezone from the format "+07:30" to "+0730" (removing the colon) which
 * can then be parsed properly.
 *
 * 2011-06-06T21:00:00+01:00
 *
 */
- (NSString *)applyTimezoneFixForDate:(NSString *)date {
    NSRange colonRange = [date rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@":"] options:NSBackwardsSearch];
    return [date stringByReplacingCharactersInRange:colonRange withString:@""];
}

-(void)setNotification:(Programme *)programme {

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    if (localNotification == nil) {
        return;
    }
    
    // Set the current time
    NSDate *timeNow = [NSDate date];
    
    // Figure out the time for the programme
    NSLog(@"Prog time = %@", programme.fullTime);

    // Fix the date colon issue
    NSString *fixedDateString = [self applyTimezoneFixForDate:programme.fullTime];
    NSLog(@"Fixed prog time = %@", fixedDateString);
    
    // Create a date formatter to create a date from the string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];

    // Create the fireDateTime object, and release the formatter
    NSDate* fireDateTime = [formatter dateFromString:fixedDateString];
    [formatter release];
    
    NSLog(@"Actual prog time = %@", fireDateTime);
    
    // Create a time 5 mins before the prog start time
    // NSDate *fireTime = [fireDateTime addTimeInterval:(-(5*60))];
    
    // Create a dummy time 10 secs in the future for testing purposes
    NSDate *fireTime = [timeNow addTimeInterval:10];
    NSLog(@"timeNow = %@", timeNow);
    NSLog(@"fireDate = %@", fireTime);
    
    // Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[displayProgramme title] forKey:@"ProgrammeTitle"];
    localNotification.userInfo = infoDict;
    
    localNotification.fireDate = fireTime;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = [NSString stringWithFormat:@"%@ will start in 5 mins", [displayProgramme title]];
    localNotification.alertAction = NSLocalizedString(@"Show me", nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    
    NSLog(@"Setting reminder");
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [localNotification release];
    
}

#pragma mark -
#pragma mark RestKit delegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    // Delegate method for RestKit to handle responses
    
    //if ([response isOK]) {  
        
    NSLog(@"Response received");
        NSLog(@"Response = %d", response.statusCode);
        NSLog(@"URL = %@", response.URL);
        NSLog(@"Request = %@", request.resourcePath);
    //}
    
}

#pragma mark -
#pragma mark Custom methods

-(IBAction)dismissView {
    
    [self dismissModalViewControllerAnimated:YES];

}

-(IBAction)watchProgramme{
    
    // Action to handle flagging a programme as being watched, and setting a notification
    
    NSLog(@"Firing the watchProgramme action");
    NSLog(@"Tweet text = %@", tweetText.text);
    NSLog(@"Programme ID = %d", displayProgramme.programmeID);
    NSLog(@"Twitter user = %@", twitterUser);
    
    
    // First off, create a RestKit reachability observer based on the RKClient singleton
    // RKReachabilityObserver *networkStatusObserver = [[RKClient sharedClient] baseURLReachabilityObserver];
    
    // Check if we can see the network before we try and update anything
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
        NSLog(@"Huzzah, we can see the network!");
        
        // Cast the programme id int into an NSNumber so it'll go into the dictionary
        NSNumber *programmeIDasNSNumber = [NSNumber numberWithInt:displayProgramme.programmeID];

        // Set up some temporary params to fire at the wewatch end
        NSDictionary *watchParams = [NSDictionary dictionaryWithObjectsAndKeys:programmeIDasNSNumber, @"intention[broadcast_id]", twitterUser, @"username", tweetText.text, @"intention[comment]", @"0", @"intention[tweet]", nil];
        
        // Hit the wewatch server with a POST
        [[RKClient sharedClient] post:@"/intentions.json" params:watchParams delegate:self];

        // Get rid of the keyboard
        [tweetText resignFirstResponder];
        
        // As an interim measure, pop up an alert
        NSString *alertString = [NSString stringWithFormat:@"No built yet..."];
        
        // Set up the string with the username in it
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Watching..."
                              message: alertString
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        // Fire the createNotification action if the switch is set
        if (reminderSwitch.on) {
            [self setNotification:[self displayProgramme]];
        }
        
        //[self dismissView];
    } else {
        NSLog(@"Dammit, the network's not available :(");
        
        // As an interim measure, pop up an alert
        NSString *alertString = [NSString stringWithFormat:@"I can't reach the WeWatch servers. Please try later..."];
        
        // Set up the string with the username in it
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Sorry..."
                              message: alertString
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [reachable release];
}


- (BOOL)textFieldShouldReturn:(UITextView *)textField {
    [tweetText resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
      {
        [tweetText resignFirstResponder];
        return NO;
      }
    return YES;
}

-(IBAction)resignTextViewFirstResponder {
    [tweetText resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [titleLabel release];
    [subtitleLabel release];
    [channelLabel release];
    [timeLabel release];
    [durationLabel release];
    [programmeImage release];
    [watchingFlag release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up the tweet textArea
    [tweetText setDelegate:self];
    
    tweetText.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    tweetText.layer.borderColor = [[UIColor grayColor] CGColor];
    tweetText.layer.cornerRadius = 8.0f;
    tweetText.layer.borderWidth = 1.0f;
    tweetText.layer.masksToBounds = YES;
    
    // Set the label values for the detail view
    [titleLabel setText:[displayProgramme title]];
    [subtitleLabel setText:[displayProgramme subtitle]];
    [channelLabel setText:[displayProgramme channel]];
    [timeLabel setText:[displayProgramme time]];
    [durationLabel setText:[displayProgramme duration]];
    
    // Set the image view to display the image that was passed in
    [programmeImage setImage:providedProgrammeImage];
    
    NSLog(@"The modal view has finished loading!");

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
