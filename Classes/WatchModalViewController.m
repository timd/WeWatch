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
#import "GTMNSString+HTML.h"
#import "SVProgressHUD.h"

@implementation WatchModalViewController

@synthesize displayProgramme;
@synthesize providedProgrammeImage;
@synthesize twitterEngine;
@synthesize twitterUser;

NSString * const didWatchProgrammeNotification = @"didWatchProgramme";

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
    // NSLog(@"Prog time = %@", programme.fullTime);

    
    // Create a date formatter to create a date from the string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];

    //Fix the date colon issue
    NSString *fixedDateString = [self applyTimezoneFixForDate:programme.fullTime];
    NSLog(@"Fixed prog time = %@", fixedDateString);

    // Create the fireDateTime object, and release the formatter
    NSDate* fireDateTime = [formatter dateFromString:fixedDateString];
    [formatter release];
    
    NSLog(@"Actual prog time = %@", fireDateTime);
    
    // Create a time 5 mins before the prog start time
    NSDate *fireTime = [fireDateTime dateByAddingTimeInterval:(-(5*60))];
    
    // Create a temporary firetime
    // NSDate *currentDate = [NSDate date];
    // NSDate *fireTime = [currentDate dateByAddingTimeInterval:30];
     
    // Create a dummy time 10 secs in the future for testing purposes
    // NSDate *fireTime = [timeNow dateByAddingTimeInterval:10];
    NSLog(@"timeNow = %@", timeNow);
    NSLog(@"fireDate = %@", fireTime);
    
    // Specify custom data for the notification
    // Create array of keys
    NSArray *keysArray = [[NSArray alloc] initWithObjects:@"programmeTitle", @"programmeID", nil];
    
    // Create values for the keys
    NSString *programmeTitleValue = [displayProgramme title];
    NSNumber *programmeIDValue = [NSNumber numberWithInt:[displayProgramme programmeID]];
    
    NSArray *valuesArray = [[NSArray alloc] initWithObjects:programmeTitleValue, programmeIDValue, nil];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    
    [valuesArray release];
    [keysArray release];
                              
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
#pragma mark ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"ASIHTTPRequest Response received: %@", responseString);
    
    [SVProgressHUD dismiss];
    
    [self dismissView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"ASIHTTPRequest error: %@", error);
    
    NSString *messageString = [NSString stringWithFormat:@"Unfortunately something has gone wrong. The error code from WeWatch is %d. Please try again later.", error];
    // Set up the string with the username in it
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Problem"
                          message: messageString
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [self dismissView];
    
}
/*
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    // Delegate method for RestKit to handle responses
    
    //if ([response isOK]) {  
        
        NSLog(@"Response received");
        NSLog(@"Response = %d", response.statusCode);
        NSLog(@"URL = %@", response.URL);
        NSLog(@"Request = %@", request.resourcePath);
    
    NSString *messageString = [NSString stringWithFormat:@"WeWatch message:%d", response.statusCode];
    // Set up the string with the username in it
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Watching..."
                          message: messageString
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
     
    [self dismissView];
    
}
*/

#pragma mark -
#pragma mark Custom methods

-(IBAction)dismissView {
    
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];

}


-(IBAction)watchProgramme{
    
    // Action to handle flagging a programme as being watched, and setting a notification
    
    // Check if we can see the network before we try and update anything
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
        NSLog(@"Huzzah, we can see the network!");
        
        // Set up the URL of the WeWatch API
        // Will be in the form
        //
        //      http://wewatch.co.uk/intentions.json?intention[comment]=comment&broadcast_id=XXXXX&username=NNNNNN&intention[comment]=tweetcontent&intention[tweet]=0
        //
        
        // Cast the programme id int into an NSNumber so it'll go into the dictionary
        NSNumber *programmeIDasNSNumber = [NSNumber numberWithInt:displayProgramme.programmeID];
        
        NSString *baseString = @"http://wewatch.co.uk/intentions.json?";
        
        NSString * encodedComment = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)tweetText.text,
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                        kCFStringEncodingUTF8);
        
        NSString *comment = [NSString stringWithFormat:@"intention[comment]=%@",encodedComment];
        
        [encodedComment release];
        
        NSString *username = [NSString stringWithFormat:@"username=%@", twitterUser];
        NSString *broadcast = [NSString stringWithFormat:@"intention[broadcast_id]=%@", programmeIDasNSNumber];
        
        // Set up switch for tweeting via WeWatch
        NSString *intention;
        if (tweetSwitch.on) {
            // If tweetState is YES, send a 1
            intention = @"intention[tweet]=1";
        } else {
            // otherwise send a zero and don't tweet
            intention = @"intention[tweet]=0";
        }
        
        // Set up inbuilt reminder
        if (reminderSwitch.on) {
            [self setNotification:displayProgramme];
        }

        // Build API query
        NSString *queryString = [NSString stringWithFormat:@"%@&%@&%@&%@", comment, username, broadcast, intention];

        NSString *fullURLString = [NSString stringWithFormat:@"%@%@", baseString, queryString];
        
        NSLog(@"Query = %@", queryString);
        NSLog(@"URL = %@", fullURLString);
        
        // Fire query at API
        NSURL *url = [NSURL URLWithString:fullURLString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request startAsynchronous];
        
        // Fire off the didWatchProgramme message to the notification centre so that
        // the listening classes know that they need to refresh their data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didWatchProgramme" object:self];    
        
        [SVProgressHUD showInView:self.view];
        
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
    [tweetText release];
    [reminderSwitch release];
    [tweetSwitch release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark TextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView {
    backgroundText.hidden = YES;
    int maxChars = 100;
    int charCount = [textView.text length];
    int charsLeft = maxChars - charCount;
    
    if ( (charsLeft <= 10) && (charsLeft >= 0) ) {
        textCount.textColor = [UIColor colorWithRed:1.0 green:0.44 blue:0 alpha:1.0];
    } else if (charsLeft < 0) {
        textCount.textColor = [UIColor redColor];
    } else {
        textCount.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    
    textCount.text = [NSString stringWithFormat:@"%d", charsLeft];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [tweetText setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    tweetText.textColor = [UIColor blackColor];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up the tweet textArea
    [tweetText setDelegate:self];
    
    // Set the label values for the detail view
    [titleLabel setText:[displayProgramme title]];
    
    //Set the image view to display the image that was passed in
    NSString *imageName = [[[displayProgramme channel] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@".png"];
    [channelLogo setImage:[UIImage imageNamed:imageName]];
    
    // Create custom watch button from image
    UIButton *watch = [UIButton buttonWithType:UIButtonTypeCustom];  
    UIImage *watchImage = [UIImage imageNamed:@"small-watch-button"];
                           
    [watch setBackgroundImage:watchImage forState:UIControlStateNormal];
    [watch addTarget:self action:@selector(watchProgramme) forControlEvents:UIControlEventTouchUpInside];  
    watch.frame = CGRectMake(0, 0, 84, 36);  
    UIBarButtonItem *watchButton = [[[UIBarButtonItem alloc] initWithCustomView:watch] autorelease];  

    self.navigationItem.rightBarButtonItem = watchButton;
    
    // Set up the background image of the text box
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textViewGradient"]];
    [tweetText addSubview: imgView];
    [tweetText sendSubviewToBack: imgView];
    [imgView release];

    // Set number of characters in text box
    int charsLeft = 100 - [tweetText.text length];
    textCount.text = [NSString stringWithFormat:@"%d", charsLeft];
    tweetText.backgroundColor = [UIColor clearColor];
    
    // Set up background text
    backgroundText = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 300, 21)];
    //    UILabel *backgroundText = [[UILabel alloc] initWithFrame:[tweetText frame]];
    backgroundText.text = @"Why are you watching (optional)...";
    backgroundText.backgroundColor = [UIColor clearColor];
    backgroundText.font = [UIFont fontWithName:@"Helvetica" size:15];
    backgroundText.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    [tweetText addSubview:backgroundText];
    [tweetText bringSubviewToFront:backgroundText];
    
    // Make the textarea first responder to lift the keyboard
    [tweetText becomeFirstResponder];
    
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
