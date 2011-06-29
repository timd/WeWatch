    //
//  SettingsModalViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 06/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "SettingsModalViewController.h"

@implementation SettingsModalViewController

@synthesize twitterEngine;

NSString * const didChangeTwitterLoginStatusNotification = @"didChangeTwitterLoginStatus";

#pragma mark -
#pragma mark Custom methods

-(void)changeTwitterLoginStatus {
    
    NSLog(@"Firing changeTwitterLoginStatus method");
    
    // Fire Twitter OAuth engine
    if (!twitterEngine) {
        twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        twitterEngine.consumerKey = kOAuthConsumerKey;
        twitterEngine.consumerSecret = kOAuthConsumerSecret;
    }
    
    // Check if the network is reachable or now
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
        
        // Able to reach the network, therefore attempt to switch the Twitter login status
        
        if (![self checkTwitterLoginStatus]) {
            
            NSLog(@"No authorised Twitter user found");
            
            // There isn't an authorised user, so it makes sense to present the Twitter login page
            UIViewController *OAuthController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine delegate:self];
            
            // If there is a controller present, display the OAuthController's modal window
            if (OAuthController) {
                [self presentModalViewController:OAuthController animated:YES];
            }
            // NSLog(@"Finished with oAuth");
            
            // Fire off the didChangeTwitterLoginStatus message to the notification centre so that
            // the listening classes know that they need to refresh their data
            [[NSNotificationCenter defaultCenter] postNotificationName:didChangeTwitterLoginStatusNotification object:self];
            
            // We're logged in, display the blue logo and update the text
            twitterLoginButton.hidden = YES;
            twitterLabel.hidden = NO;
            twitterUsername.hidden = NO;
            twitterUsername.text = [NSString stringWithFormat:@"%@", [twitterEngine username]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            // There IS a valid twitter user around
            // As we've found an authorised user, it makes sense to log them out...
            [twitterEngine clearAccessToken];
            [twitterEngine clearsCookies];
            [twitterEngine setUsername:NULL password:NULL];
            
            // Change the text of the login button
            twitterLoginButton.titleLabel.text = @"Login";
            
            // Fire off the didChangeTwitterLoginStatus message to the notification centre so that
            // the listening classes know that they need to refresh their data
            [[NSNotificationCenter defaultCenter] postNotificationName:didChangeTwitterLoginStatusNotification object:self];
            
        }
        
    } else {
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

-(BOOL)checkTwitterLoginStatus {
    
    // Check if the user is already authorised
    // Not going to bother checking if the network is reachable, because
    // the calling function has already done that
    
    // Check if Twitter user is logged in
    
    if (![twitterEngine isAuthorized]) {
        // They aren't
        return FALSE;
    } else {
        // They are...
        return TRUE;
    }
    
}

#pragma mark -
#pragma mark Instance methods

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

-(IBAction)dismissView {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.title = @"About";
    
    
    if (!twitterEngine) {
        twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        twitterEngine.consumerKey = kOAuthConsumerKey;
        twitterEngine.consumerSecret = kOAuthConsumerSecret;
    }
    
    NSLog(@"Twitter status = %d", [self.twitterEngine isAuthorized]);
    // Check the twitter login status and update the twitter logo accordingly
    if ([self checkTwitterLoginStatus]) {
        // We're logged in, display the username
        twitterLoginButton.hidden = YES;
        twitterUsername.text = [NSString stringWithFormat:@"%@", [twitterEngine username]];
        twitterUsername.hidden = NO;
        twitterLabel.hidden = NO;
        
    } else {
        // Not logged in, display the grey one and update the text
        twitterUsername.hidden = YES;
        twitterLabel.hidden = YES;
        
        UIImage *buttonImage = [UIImage imageNamed:@"twitterLoginButton"];
        [twitterLoginButton setImage:buttonImage forState:UIControlStateNormal];

        twitterLoginButton.hidden = NO;

    }
  
    // Write out a list of the notifications as a bug check
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *notification in notifications) {  
        
        NSDictionary *userInfo = notification.userInfo;
        
        NSString *programmeTitle = [userInfo valueForKey:@"programmeTitle"];
        NSString *programmeID = [userInfo valueForKey:@"programmeID"];
        
        NSLog(@"Title = %@ / ID = %@", programmeTitle, programmeID);
        
    }
    
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
