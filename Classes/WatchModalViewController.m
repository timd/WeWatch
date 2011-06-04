//
//  WatchModalViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 03/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "WatchModalViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WatchModalViewController

@synthesize displayProgramme;
@synthesize providedProgrammeImage;

#pragma mark -
#pragma mark RestKit delegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    // Delegate method for RestKit to handle responses
    
    if ([response isOK]) {  
        
        NSLog(@"Response = %d", response.statusCode);
        NSLog(@"URL = %@", response.URL);
        NSLog(@"Request = %@", request.resourcePath);
    }
    
}


#pragma mark -
#pragma mark Custom methods

-(IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)watchProgramme{
    
    NSLog(@"Firing the watchProgramme action");
    NSLog(@"Tweet text = %@", tweetText.text);
    
    // First off, create a RestKit reachability observer based on the RKClient singleton
    RKReachabilityObserver *networkStatusObserver = [[RKClient sharedClient] baseURLReachabilityObserver];
    
    // Check if we can see the network before we try and update anything
    if ([networkStatusObserver isNetworkReachable]) {
        NSLog(@"Huzzah, we can see the network!");

        // Set up some temporary params to fire at the wewatch end
        NSDictionary *watchParams = [NSDictionary dictionaryWithObjectsAndKeys:@"44997", @"intention[broadcast_id]", @"timd", @"username", @"", @"intention[comment]", @"0", @"intention[tweet]", nil];
        
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
