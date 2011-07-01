//
//  ProgrammeTabViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 30/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ProgrammeTabViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "Programme.h"
#import "Constants.h"

#import "ProgrammeDetailViewController.h"
#import "ProgrammeCommentViewController.h"

@implementation ProgrammeTabViewController

@synthesize displayProgramme = _displayProgramme;
@synthesize twitterEngine = _twitterEngine;

#define kDetailsButton 1010
#define kCommentsButton 1020

NSString * const didUnwatchProgrammeNotification = @"didUnwatchProgramme";

#pragma mark -
#pragma mark Custom methods

-(IBAction)swapViews:(id)sender {
    
    if ( [sender tag] == kDetailsButton ) {

        // Check if the view controller already exists
        _programmeDetailVC = [[ProgrammeDetailViewController alloc] init];
        [_programmeDetailVC setDisplayProgramme:self.displayProgramme];
        
        // Add the subview so it's visible
        [bodyView addSubview:_programmeDetailVC.view];
        
        // Swap the tab bar image around
        tabBarImage.image = [UIImage imageNamed:@"tabBar-details"];

    } else if ( [sender tag] == kCommentsButton ) {

        // check if the tab view controller already exists
        _programmeCommentVC = [[ProgrammeCommentViewController alloc] init];
        [_programmeCommentVC setProgrammeTitle:[self.displayProgramme title]];
        
        // Add the subview so it's visible
        [bodyView addSubview:_programmeCommentVC.view];
        
        // Swap the tab bar image around
        tabBarImage.image = [UIImage imageNamed:@"tabBar-comments"];
    
    }
    
}

#pragma mark -
#pragma mark Object methods

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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - 
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Register this class so that it can listen out for didWatchProgramme and didUnwatchProgramme notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveWatchProgrammeMessage) 
                                                 name:@"didWatchProgramme" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveUnwatchProgrammeMessage) 
                                                 name:@"didUnwatchProgramme" 
                                               object:nil];
    
    // Load in the detail view controller as the default view
    // Check if the detail view controller already exists
    _programmeDetailVC = [[ProgrammeDetailViewController alloc] init];
    [_programmeDetailVC setDisplayProgramme:_displayProgramme];
    
    // Add the subview so it's visible
    [bodyView addSubview:_programmeDetailVC.view];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [watchButton release];
    watchButton = nil;
    
    [detailButton release];
    detailButton = nil;
    
    [commentButton release];
    commentButton = nil;
    
    [watchButtonLabel release];
    watchButtonLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)watchProgramme{
    NSLog(@"Fired watchProgramme method");
    
    // Check to see if we're already logged into twitter - if yes, can present the modal window
    // directly - if no; then we have to pop up the modal Twitter login window
    // Fire up Twitter OAuth engine, if it's not already in existence
    if (!_twitterEngine) {
        _twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _twitterEngine.consumerKey = kOAuthConsumerKey;
        _twitterEngine.consumerSecret = kOAuthConsumerSecret;
    }
    
    // Check if the user is already authorised
    
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
        // Able to reach the network, therefore attempt to login via Twitter
        
        if (![_twitterEngine isAuthorized]) {
            
            NSLog(@"ProgrammeDetailViewController:: is NOT logged into Twitter");
            
            // Clear the cookies to stop the Woah! error
            [_twitterEngine clearsCookies];
            
            // There isn't an authorised user, so it makes sense to present the Twitter login page
            UIViewController *OAuthController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_twitterEngine delegate:self];
            
            // If there is a controller present, display the OAuthController's modal window
            if (OAuthController) {
                [self presentModalViewController:OAuthController animated:YES];
            }
            NSLog(@"Finished with oAuth");
            
            // Twitter login is now complete, so show the modalWatch page
            
            NSLog(@"Twitter name = %@", [_twitterEngine username]);
            
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
            
            if ([_displayProgramme amWatching] == TRUE) {
                
                /*
                 *  UNWATCH METHOD
                 *  
                 *  Don't need to check if the network's available, that's already been done...
                 *
                 */
                
                // grab the programme watch_id
                NSNumber *watch_id = [NSNumber numberWithInt:_displayProgramme.watchingID];
                
                NSString *requestURLString = [NSString stringWithFormat:@"http://wewatch.co.uk/intentions/%@.json?username=%@", watch_id, [_twitterEngine username]];
                //NSLog(@"*** Unwatch URL = %@", requestURLString);
                
                NSURL *requestURL = [NSURL URLWithString:requestURLString];
                
                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
                [request setDelegate:self];
                [request setRequestMethod:@"DELETE"]; 
                [request startAsynchronous];
                
                NSLog(@">>> REQUEST = %@", request);
                _requestMade = request;
                
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
    [modalViewController setDisplayProgramme:_displayProgramme];
    
    // Pass in the retrieved Programme image so we don't have to bugger about loading it in the modal view controller...
    // [modalViewController setProvidedProgrammeImage:retrievedProgrammeImage];
    
    // Pass in the current Twitter user
    [modalViewController setTwitterUser:[_twitterEngine username]];
    
    // Pass in the current Twitter engine
    [modalViewController setTwitterEngine:_twitterEngine];
    
    // Present the modalViewController with a horizontal flip
    [self.navigationController pushViewController:modalViewController animated:YES];
    [modalViewController release];
    
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
        
        NSNumber *currentProgrammeID = [NSNumber numberWithInt:[_displayProgramme programmeID]];
        
        if ( [notificationProgrammeID isEqualToNumber:currentProgrammeID] ) {
            // We're looking at the notification for the current programme
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            NSLog(@"Cancelled");
        }
        
    }
    
    // if the watch icon button is showing, switch it off
    //    if ( ![reminderButton isHidden] ) {
        // It's showing, toggle it
        //        [reminderButton setHidden:YES];
        //    }
    
}

#pragma mark -
#pragma mark LoadImageDelegate methods

-(void)didLoadImage:(UIImage *)retrievedImage {
    
    // Programme image has been successfully loaded by LoadImage, so set the programme image to the one which was retrieved
    //    UIImage *webButtonBackground = [self imageWithBorderFromImage:retrievedImage];
    //    [webButton setBackgroundImage:webButtonBackground forState:UIControlStateNormal];
    
    // Set the ivar for the programme image to the retrieved one
    //    retrievedProgrammeImage = webButtonBackground;
    
    [_spinner stopAnimating];
    
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


@end
