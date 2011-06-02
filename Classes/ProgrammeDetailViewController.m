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
#import "WeWatchAppDelegate.h"

// Define Twitter OAuth settings
#define kOAuthConsumerKey @"eQ0gA08Yl4uSrrhny0vew"
#define kOAuthConsumerSecret @"sL2E2nX1RWvHLaCOmLYXkoqgiHl7CxanhCLq2PGDtk"


@implementation ProgrammeDetailViewController

@synthesize displayProgramme;
@synthesize twitterEngine;
@synthesize loadProgrammeImageOperation;

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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Reachability methods

-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"wewatch.co.uk"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark LoadProgrammeImageOperationDelegate methods

-(void)LoadProgrammeImageOperation:(NSOperation *)theProgrammeImageOperation didLoadProgrammeImage:(UIImage *)retrievedImage;
{
	// Programme image has been successfully loaded, so set the programme image to the one which was retrieved
    NSLog(@"LoadProgrammeImageOperation completed, and called delegate method");
    [programmeImage setImage:retrievedImage];
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

    // Set the programme image to the generic one, so that when the detail view loads
    // it doesn't load with the previously-viewed programme's image
    [programmeImage setImage:[UIImage imageNamed:@"wewatch.png"]];
    
    // Check if the network is reachable:
    if ([self reachable]) {

        NSLog(@"Firing queued image retrieval");
        
        [NSURL URLWithString:[displayProgramme programmeImage]];

        // Fire off loadProgrammeImageOperation
        self.loadProgrammeImageOperation = [[LoadProgrammeImageOperation alloc] initWithProgrammeImageURL:[NSURL URLWithString:[displayProgramme programmeImage]]];
        
        self.loadProgrammeImageOperation.delegate = self;
        
        // Create queue and add retrieval job
        NSOperationQueue *operationQueue = [(WeWatchAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
        [operationQueue addOperation:self.loadProgrammeImageOperation];
        
        NSLog(@"Called queued image retrieval");
        
        // Download the programme image
        // [programmeImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[displayProgramme programmeImage]]]]];
                                            
    } else {
        // Can't get to the network; use a canned image
        NSLog(@"Unable to download the image");
        // [programmeImage setImage:[UIImage imageWithContentsOfFile:@"wewatch.png"]];
        [programmeImage setImage:[UIImage imageNamed:@"wewatch.png"]];
    }
    
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
    
    // Set the background to match the table view
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

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
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	NSLog(@"Authenticated with user %@", username);
    
}

#pragma mark -
#pragma mark Watch programme methods

-(void)watchProgramme{
    NSLog(@"Fired watchProgramme method");
    
    // TODO: Build and send request to WeWatch to update the watcher count
    
    
    // Set up temporary alert view
    
    NSString *alertString;
    
    if ([twitterEngine username] != NULL) {
        
        alertString = [NSString stringWithFormat:@"Not yet built - you are logged in as %@", [twitterEngine username]];
    } else {
        alertString = @"Not yet built - nobody is logged in at the moment";
    }
    
    // Set up the string with the username in it
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Watching..."
                          message: alertString
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
