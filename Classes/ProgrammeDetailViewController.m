//
//  ProgrammeDetailViewController.m
//  WeWatchTabled
//
//  Created by Tim Duckett on 15/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ProgrammeDetailViewController.h"
#import "Programme.h"
#import "SA_OAuthTwitterEngine.h"
#import "LoadProgrammeImageOperation.h"
#import "LoadImage.h"
#import "WeWatchAppDelegate.h"

// Define Twitter OAuth settings
#define kOAuthConsumerKey @"eQ0gA08Yl4uSrrhny0vew"
#define kOAuthConsumerSecret @"sL2E2nX1RWvHLaCOmLYXkoqgiHl7CxanhCLq2PGDtk"


@implementation ProgrammeDetailViewController

@synthesize displayProgramme;
@synthesize twitterEngine;
@synthesize loadImageOperation;
@synthesize retrievedProgrammeImage;
@synthesize forceDataReload;

NSString * const didUnwatchProgrammeNotification = @"didUnwatchProgramme";

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
    [descriptionLabel release];
    [durationLabel release];
    [watchersLabel release];
    [programmeImage release];
    [retrievedProgrammeImage release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark LoadImageDelegate methods

-(void)didLoadImage:(UIImage *)retrievedImage {

    // Programme image has been successfully loaded by LoadImage, so set the programme image to the one which was retrieved
    UIImage *webButtonBackground = [self imageWithBorderFromImage:retrievedImage];
    [webButton setBackgroundImage:webButtonBackground forState:UIControlStateNormal];
    
    // Set the ivar for the programme image to the retrieved one
    retrievedProgrammeImage = webButtonBackground;
    
    [spinner stopAnimating];

}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    
    // Call the superclass method
    [super viewWillAppear:animated];
    
    // Set the label values for the detail view
    [titleLabel setText:[displayProgramme title]];
    [subtitleLabel setText:[displayProgramme subtitle]];
    [descriptionLabel setText:[displayProgramme description]];
    [channelLabel setText:[displayProgramme channel]];
    [timeLabel setText:[displayProgramme time]];
    [durationLabel setText:[displayProgramme duration]];
    [watchersLabel setText:[NSString stringWithFormat:@"%d", [displayProgramme watchers]]];
    
    //commentCountLabel.hidden = YES;
    
    //Set the image view to display the image that was passed in
    NSString *imageName = [[[displayProgramme channel] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@".png"];
    [channelIcon setImage:[UIImage imageNamed:imageName]];
    
    // Set up the watching flag, depending on whether I'm going to watch the programme or not
    if ([displayProgramme amWatching] == TRUE) {

        // Set the watching flag status
        watchingFlag.hidden = FALSE;
        
    } else {

        watchingFlag.hidden = TRUE;

    }
    
    // Check if there's a reminder set for this programme; if there is
    // then make the "unremind" button available for use
    
    // Check to see if this programme exists within the notifications
    // and cancel if it does
    NSArray *setNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // Force the reminder flag to the default of NO
    [displayProgramme setReminderFlag:NO];
    
    for (UILocalNotification *notification in setNotifications) {
        // Grab the user info dictionary
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *notificationProgrammeID = [userInfo valueForKey:@"programmeID"];
        
        NSNumber *currentProgrammeID = [NSNumber numberWithInt:[displayProgramme programmeID]];
        
        if ( [notificationProgrammeID isEqualToNumber:currentProgrammeID] ) {
            // We have found a reminder for this programme
            [displayProgramme setReminderFlag:YES];
        }
    }
    
    // Switch on or off the reminder button
    if ( [displayProgramme reminderFlag] ) {
        [reminderButton setHidden:NO];
    } else {
        [reminderButton setHidden:YES];
    }
    

    // Set the programme image to the generic one, so that when the detail view loads
    // it doesn't load with the previously-viewed programme's image
    //    [programmeImage setImage:[UIImage imageNamed:@"wewatch.png"]];
    UIImage *webButtonBackground = [self imageWithBorderFromImage:[UIImage imageNamed:@"wewatch.png"]];
    [webButton setBackgroundImage:webButtonBackground forState:UIControlStateNormal];
    
    // Set the programme image held in the ivar to the default
    retrievedProgrammeImage = [UIImage imageNamed:@"wewatch.png"];
    
/*
    // Grab the frame of the UIButton
    CGRect buttonFrame = [webButton frame];
    NSLog(@"Button X = %f", buttonFrame.origin.x);
    NSLog(@"Button Y = %f", buttonFrame.origin.y);
    NSLog(@"Button H = %f", buttonFrame.size.height);
    NSLog(@"Button W = %f", buttonFrame.size.width);
    
    // Create a view to slap over the button
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height)];
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(57, 23, 40, 40)];
    
    [buttonView addSubview:spinner];
    [spinner startAnimating];
    [self.view addSubview:buttonView];
*/
    
    // Check if the network is reachable:
    Reachable *reachable = [[Reachable alloc] init];

    if ([reachable isReachable]) {

        NSLog(@"Firing queued image retrieval");
        
        [NSURL URLWithString:[displayProgramme programmeImage]];

        // Fire off loadImage 
        self.loadImageOperation = [[LoadImage alloc] initWithProgrammeImageURL:[NSURL URLWithString:[displayProgramme programmeImage]]];
        
        self.loadImageOperation.delegate = self;
        
        // Fire off loadProgrammeImageOperation
        //        self.loadProgrammeImageOperation = [[LoadProgrammeImageOperation alloc] initWithProgrammeImageURL:[NSURL URLWithString:[displayProgramme programmeImage]]];
        
        //        self.loadProgrammeImageOperation.delegate = self;
        
        // Create queue and add retrieval job
        NSOperationQueue *operationQueue = [(WeWatchAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
        [operationQueue addOperation:self.loadImageOperation];
        
        NSLog(@"Called queued image retrieval");
        
        // Download the programme image
        // [programmeImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[displayProgramme programmeImage]]]]];
                                            
    } else {
        // Can't get to the network; use a canned image
        NSLog(@"Unable to download the image");
        // [programmeImage setImage:[UIImage imageWithContentsOfFile:@"wewatch.png"]];
        //        [programmeImage setImage:[UIImage imageNamed:@"wewatch.png"]];
        [webButton setBackgroundImage:[UIImage imageNamed:@"wewatch.png"] forState:UIControlStateNormal];
    }
    
    [reachable release];
    
   // Extract the names from the watchers names array
    if ([[displayProgramme watcherNames] count] != 0) {
        
        NSMutableString *watchersNamesLabelText = [[NSMutableString alloc] init];
        
        // there is some content in the watcherNames array
        for (NSString *name in [displayProgramme watcherNames]) {
            NSLog(@"Watcher name = %@", name);
            [watchersNamesLabelText appendString:name];
            NSLog(@"Watcher name 2 = %@", watchersNamesLabelText);
        }
        NSLog(@"List of watchers: %@", watchersNamesLabelText);
        
        [watchersNamesLabel setText:watchersNamesLabelText];
        
        [watchersNamesLabelText release];
        
    } else {
        [watchersNamesLabel setText:@""];
    }
    
     // Change the navigation item
     //[[self navigationItem] setTitle:[NSString stringWithFormat:@"%@ %@", [displayProgramme channel], [displayProgramme time]]];
     
    // Set the background colour
    [self.view setBackgroundColor:[UIColor whiteColor]];
     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up the image in the navigation bar
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 44.0)];
    [imgView setImage:[UIImage imageWithContentsOfFile:@"detailNavBar"]];
    [self.navigationController.navigationBar insertSubview:imgView atIndex:0];
    NSLog(@"Changing navbar image");
    
    [imgView release];

    
    // Set the background to match the table view
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    // Register this class so that it can listen out for didWatchProgramme and didUnwatchProgramme notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveWatchProgrammeMessage) 
                                                 name:@"didWatchProgramme" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveUnwatchProgrammeMessage) 
                                                 name:@"didUnwatchProgramme" 
                                               object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

    [titleLabel release];
    titleLabel = nil;
    
    [subtitleLabel release];
    subtitleLabel = nil;
    
    [channelLabel release];
    channelLabel = nil;
    
    [timeLabel release];
    timeLabel = nil;
    
    [descriptionLabel release];
    descriptionLabel = nil;
    
    [durationLabel release];
    durationLabel = nil;
    
    [watchersLabel release];
    watchersLabel = nil;
    
    [programmeImage release];
    programmeImage = nil;
    
    [watchersNamesLabel release];
    watchersNamesLabel = nil;
    
    [watchingFlag release];
    watchingFlag = nil;
    
    [channelIcon release];
    channelIcon = nil;
    
    [reminderButton release];
    reminderButton = nil;
    
    [webButton release];
    webButton = nil;
    
    [commentCountLabel release];
    commentCountLabel = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//=============================================================================================================================
#pragma mark -
#pragma mark Web View methods

-(IBAction)pushWebView {
    
    // Check if the programmeURL is empty - if it is, do nowt
    if ( [displayProgramme programmeURL] != nil ) {
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [displayProgramme programmeURL]]];
     
        // Create the web view controller
        // ProgrammeSiteViewController *siteViewController = [[ProgrammeSiteViewController alloc] initWithNibName:@"ProgrammeSiteViewController" bundle:nil];
        
        // Pass in the Programme's URL to the siteViewController
        // [siteViewController setProgrammeSiteURL:[displayProgramme programmeURL]];
        
        // Present the web view controller:
        // [self.navigationController pushViewController:siteViewController animated:YES];
        
        // Release the view controller
        // [siteViewController release];
        
        return;
        
    } else {
        
        // Pop up an alert to say sorry, no can do
        NSString *alertString = @"  I don't know the web address for this programme :(";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..." 
                                                        message:alertString 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        
        [alert release];
        
        return;
        
    }
    
    
}

-(IBAction)showDetailsView{
    NSLog(@"showDetailsView button pressed");
}

-(IBAction)showCommentsView{
    NSLog(@"showCommentsView button pressed");
}

-(UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

//=============================================================================================================================
#pragma mark -
#pragma mark SA_OAuthTwitterEngineDelegate

- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username {
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *)username {
    
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {

    NSLog(@"Fired OAuthTwitterController:authenticatedWithUsername:");
	NSLog(@"Authenticated with user %@", username);
    
    //[self flipModalWatchPage];
    
}

-(void)alterWatchersNumberBy:(int)incValue {

    // Update the watchers total : grab the current watcher's text
    int currentWatchers = [displayProgramme watchers];
    NSLog(@"CURRENTLY WATCJING: %d", displayProgramme.watchers);
    
    // Increment the watchers number by 1
    currentWatchers = currentWatchers + incValue;
    
    [displayProgramme setWatchers:currentWatchers];
    NSLog(@"NOW WATCHIN: %d", displayProgramme.watchers);

}

#pragma mark -
#pragma mark Notification methods

// Received a didWatchProgramme or didUnwatchProgramme essage via the 
// notification centre, so we need to set the forceDataReload flag to 
// ensure that the data gets refreshed when the view reappears

-(void)didReceiveWatchProgrammeMessage {
    NSLog(@"*** ProgrammeDetailViewController didReceiveWatchProgrammeMessage");
    
    [self alterWatchersNumberBy:1];
    
    self.forceDataReload = YES;
    [displayProgramme setAmWatching:YES];
}

-(void)didReceiveUnwatchProgrammeMessage {

    if (displayProgramme.watchers != 0) {
        [self alterWatchersNumberBy:-1];
    }
    
    NSLog(@"*** ProgrammeDetailViewController didReceiveUnwatchProgrammeMessage");
    [displayProgramme setAmWatching:NO];
}

#pragma mark -
#pragma mark Watch programme methods

-(void)watchProgramme{
    NSLog(@"Fired watchProgramme method");
    
    // Check to see if we're already logged into twitter - if yes, can present the modal window
    // directly - if no; then we have to pop up the modal Twitter login window
    // Fire up Twitter OAuth engine, if it's not already in existence
    if (!twitterEngine) {
        twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        twitterEngine.consumerKey = kOAuthConsumerKey;
        twitterEngine.consumerSecret = kOAuthConsumerSecret;
    }
    
    // Check if the user is already authorised
    
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
        // Able to reach the network, therefore attempt to login via Twitter
        
        if (![twitterEngine isAuthorized]) {
            
            NSLog(@"ProgrammeDetailViewController:: is NOT logged into Twitter");
            
            // Clear the cookies to stop the Woah! error
            [twitterEngine clearsCookies];
            
            // There isn't an authorised user, so it makes sense to present the Twitter login page
            UIViewController *OAuthController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine delegate:self];
            
            // If there is a controller present, display the OAuthController's modal window
            if (OAuthController) {
                [self presentModalViewController:OAuthController animated:YES];
            }
            NSLog(@"Finished with oAuth");

            // Twitter login is now complete, so show the modalWatch page
            
            NSLog(@"Twitter name = %@", [twitterEngine username]);
            
            // [self showModalWatchPage];
            
            /*
            // Create the Watch modal view controller
            WatchModalViewController *modalViewController = [[WatchModalViewController alloc] initWithNibName:@"WatchModalViewController" bundle:nil];
            modalViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            // Pass in the Programme to the modalViewController
            [modalViewController setDisplayProgramme:displayProgramme];
            
            // Pass in the retrieved Programme image so we don't have to bugger about loading it in the modal view controller...
            [modalViewController setProvidedProgrammeImage:retrievedProgrammeImage];
            
            // Pass in the current Twitter user
            [modalViewController setTwitterUser:[twitterEngine username]];
            
            // Pass in the current Twitter engine
            [modalViewController setTwitterEngine:twitterEngine];
            
            // Present the modalViewController with a horizontal flip
            [self.navigationController pushViewController:modalViewController animated:YES];
            //                [self presentModalViewController:modalViewController animated:YES];
            [modalViewController release];
             
            */

 
        } else {
            
            // There IS an authorised user
            NSLog(@"ProgrammeDetailViewController:: is logged into Twitter");
            
            // As there is an authorised user, we can fire the watch/unwatch methods
            // Check to see if we're already watching the programme: if we are, fire off the unwatch action
            // Otherwise, load the modal view
            
            if ([displayProgramme amWatching] == TRUE) {
                
                /*
                 *  UNWATCH METHOD
                 *  
                 *  Don't need to check if the network's available, that's already been done...
                 *
                 */
                
                // grab the programme watch_id
                NSNumber *watch_id = [NSNumber numberWithInt:displayProgramme.watchingID];
                
                NSString *requestURLString = [NSString stringWithFormat:@"http://wewatch.co.uk/intentions/%@.json?username=%@", watch_id, [twitterEngine username]];
                //NSLog(@"*** Unwatch URL = %@", requestURLString);
                
                NSURL *requestURL = [NSURL URLWithString:requestURLString];

                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
                [request setDelegate:self];
                [request setRequestMethod:@"DELETE"]; 
                [request startAsynchronous];
                
                NSLog(@">>> REQUEST = %@", request);
                requestMade = request;
                
                // Fire off the didWatchProgramme message to the notification centre so that
                // the listening classes know that they need to refresh their data
                [[NSNotificationCenter defaultCenter] postNotificationName:didUnwatchProgrammeNotification object:self];        

                [self killReminder];
                
            } else {
                
                /*
                
                // Create the Watch modal view controller
                WatchModalViewController *modalViewController = [[WatchModalViewController alloc] initWithNibName:@"WatchModalViewController" bundle:nil];
                modalViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                
                // Pass in the Programme to the modalViewController
                [modalViewController setDisplayProgramme:displayProgramme];
                
                // Pass in the retrieved Programme image so we don't have to bugger about loading it in the modal view controller...
                [modalViewController setProvidedProgrammeImage:retrievedProgrammeImage];
                
                // Pass in the current Twitter user
                [modalViewController setTwitterUser:[twitterEngine username]];
                
                // Pass in the current Twitter engine
                [modalViewController setTwitterEngine:twitterEngine];
                
                // Present the modalViewController with a horizontal flip
                [self.navigationController pushViewController:modalViewController animated:YES];
                //                [self presentModalViewController:modalViewController animated:YES];
                [modalViewController release];
                 
                */
                
                [self showModalWatchPage];
 
            }

            
        }
        
    } else  {
        
        // Unable to reach Twitter - display an error
        NSString *alertString = [NSString stringWithFormat:@"I couldn't reach Twitter to sign you in. Please try later..."];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Sorry!"
                              message: alertString
                              delegate: nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    
    [reachable release];
    
    
}

-(void)showModalWatchPage{
    
    // Create the Watch modal view controller
    WatchModalViewController *modalViewController = [[WatchModalViewController alloc] initWithNibName:@"NewWatchModalViewController" bundle:nil];
    
    // Pass in the Programme to the modalViewController
    [modalViewController setDisplayProgramme:displayProgramme];
    
    // Pass in the retrieved Programme image so we don't have to bugger about loading it in the modal view controller...
    [modalViewController setProvidedProgrammeImage:retrievedProgrammeImage];
    
    // Pass in the current Twitter user
    [modalViewController setTwitterUser:[twitterEngine username]];
    
    // Pass in the current Twitter engine
    [modalViewController setTwitterEngine:twitterEngine];
    
    // Present the modalViewController with a horizontal flip
    [self.navigationController pushViewController:modalViewController animated:YES];
    [modalViewController release];
    
}

// ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    if ( [request isEqual:requestMade] ) {
        // We've received a response from the DELETE request, therefore it's safe to
        // go about updating the UI
        
        // TODO: check with the API that the unwatch request has worked
        
        NSLog(@"Unwatching shit");
        [self dismissCurrentView];
        
        // Hide the check flag and change the button to 'watch'
        //        watchingFlag.hidden = YES;
        //        watchButton.titleLabel.text = @"Watch";
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"ASIHTTPRequest failed with error: %@", error);
}

-(void)dismissCurrentView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)killReminder {
    // Action to find and kill the reminder for the current programme
    // Check to see if this programme exists within the notifications
    // and cancel if it does
    NSArray *setNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *notification in setNotifications) {
        // Grab the user info dictionary
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *notificationProgrammeID = [userInfo valueForKey:@"programmeID"];
        
        NSNumber *currentProgrammeID = [NSNumber numberWithInt:[displayProgramme programmeID]];
        
        if ( [notificationProgrammeID isEqualToNumber:currentProgrammeID] ) {
            // We're looking at the notification for the current programme
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            NSLog(@"Cancelled");
        }
        
    }
    
    // if the watch icon button is showing, switch it off
    if ( ![reminderButton isHidden] ) {
        // It's showing, toggle it
        [reminderButton setHidden:YES];
    }

}

@end
