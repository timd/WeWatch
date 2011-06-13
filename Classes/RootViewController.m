//
//  RootViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright Charismatic Megafauna Ltd 2011. All rights reserved.
//

#import "RootViewController.h"
#import "CJSONDeserializer.h"
#import "LoadPublicTimelineOperation.h"
#import "WeWatchAppDelegate.h"
#import "Programme.h"
#import "ProgrammeDetailViewController.h"
#import "SettingsModalViewController.h"
#import "ModalThrobberViewController.h"
#import "SVProgressHUD.h"

@implementation RootViewController

@synthesize scheduleArray;
@synthesize cleanScheduleArray;
@synthesize loadPublicTimelineOperation;

@synthesize detailViewController;
@synthesize nibLoadedCell;
@synthesize forceDataReload;

// Define custom cell content identifiers
#define PROG_TITLE_LABEL ((UILabel *)[cell viewWithTag:1010])
#define PROG_DESCRIPTION_LABEL ((UILabel *)[cell viewWithTag:1020])
#define PROG_CHANNEL_LABEL ((UILabel *)[cell viewWithTag:1030])
#define PROG_TIME_LABEL ((UILabel *)[cell viewWithTag:1040])
#define PROG_DURATION_LABEL ((UILabel *)[cell viewWithTag:1050])
#define PROG_WATCHERS_LABEL ((UILabel *)[cell viewWithTag:1060])
#define PROG_WATCHING_FLAG ((UIImageView *)[cell viewWithTag:1070])

// Define table section headers
#define HEADING_ARRAY [NSArray arrayWithObjects:@"6pm", @"7pm", @"8pm", @"9pm", @"10pm", nil]

// Define Twitter OAuth settings
#define kOAuthConsumerKey @"eQ0gA08Yl4uSrrhny0vew"
#define kOAuthConsumerSecret @"sL2E2nX1RWvHLaCOmLYXkoqgiHl7CxanhCLq2PGDtk"

-(id)init {

    [super init];    
    
    // Fire up Twitter OAuth engine, if it's not already in existence
    if (!_engine) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
    return self;
    
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register this class so that it can listen out for didWatchProgramme and didUnwatchProgramme notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveWatchProgrammeMessage) 
                                                 name:@"didWatchProgramme" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveUnwatchProgrammeMessage) 
                                                 name:@"didUnwatchProgramme" 
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveUnwatchProgrammeMessage) 
                                                 name:@"didChangeTwitterLoginStatus" 
                                               object:nil];

    
    // Fire up Twitter OAuth engine, if it's not already in existence
    if (!_engine) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
	// Set the title of the nav bar
    self.title = @"We Watch";
    
    // Set up a right-hand button on the nav bar
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] 
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:self 
                                                                      action:@selector(displaySettingsModalWindow)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    [settingsButton release];
    
    // Set up a left button as a refresh indicator
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh.png"] 
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:self 
                                                                      action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = refreshButton;
    [refreshButton release];
        
    Reachable *reachable = [[Reachable alloc] init];
    
    // Check if the network is reachable
    if ([reachable isReachable]) {
        
        // If the network's available, then load the timeline
        
        //NSLog(@"Twitter engine = %@", _engine);
        NSLog(@"Twitter auth status = %d", [_engine isAuthorized]);
        
        //NSLog(@"Reachable");
        //NSLog(@"Twitter name = %@", [_engine username]);
        
        // Start the throbber going
        [self showThrobber];
        
        // Load public timeline from the web.
        self.loadPublicTimelineOperation = [[LoadPublicTimelineOperation alloc] initWithTwitterName:[_engine username]];
        self.loadPublicTimelineOperation.delegate = self;
        
        // Check if there's a valid Twitter name; if so, set the twitterName ivar
        if ([_engine username]) {
            NSLog(@"RootViewController: twitter name = %@", [_engine username]);
        } else {
            //NSLog(@"Can't retrieve twitter name");
        }
        
        NSOperationQueue *operationQueue = [(WeWatchAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
        [operationQueue addOperation:self.loadPublicTimelineOperation];
        
        //NSLog(@"RootViewController::OPERATION QUEUE = %@", operationQueue);
        
    } else {
        
        // The network's not available, so fail with a message
        //NSLog(@"Not Reachable");
        
        NSString *alertString = [NSString stringWithFormat:@"I couldn't reach WeWatch to retrieve the programme information.\n Please try later..."];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Sorry!"
                              message: alertString
                              delegate: nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        [self stopLoading];
        
    }
    
    [reachable release];
    
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Check if the forceReload flag has been set: if yes, reload the data
    if (forceDataReload) {
        // Force a refresh
        [self refresh];
        
        // Reset the flag
        [self setForceDataReload:NO];
        
    }
    
}


/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark -
#pragma mark Throbber methods

- (IBAction)showThrobber {
    
    // Get main window reference
    UIWindow* mainWindow = (((WeWatchAppDelegate*) [UIApplication sharedApplication].delegate).window);
    
    // Create a full-screen view
    throbberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    throbberView.backgroundColor = [UIColor whiteColor];
    throbberView.alpha = 0.5f;
    
    [SVProgressHUD showInView:throbberView status:@"Loading..."];
    
    [mainWindow addSubview:throbberView];
}


- (IBAction)dismissThrobber {
    NSLog(@"Calling dismissThrobber");
    //	[SVProgressHUD dismiss];
    [throbberView removeFromSuperview];
    
}


#pragma mark -
#pragma mark UITableViewDataSource methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Number of sections is dependent on the number of timeslot arrays in the cleanScheduleArray
    //NSLog(@"There are %d sections in scheduleArray", [self.scheduleArray count]);
    return [scheduleArray count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // This depends on which section we're dealing with (numbered from 0 to n)
    // The rows come from the number of elements in the nth array in the programmeSchedule array
    
    // Get the nth array from programmeSchedule
    NSArray *nthElement = [scheduleArray objectAtIndex:section];
    
    //NSLog(@"There are %d elements in section %d", [nthElement count], section);
    
    //NSLog(@"nthElement = %@", nthElement);
    
    // Count how many elements are in this nth array, and return it
    return [nthElement count];    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Check for a reusable cell first, and use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProgrammeCell"];
    
    // If there isn't a free cell, then create one
    if (cell == nil) {
        // Create a custom cell from a nib
        [[NSBundle mainBundle] loadNibNamed:@"BaseCell" owner:self options:NULL];
        cell = nibLoadedCell;
    }
    
    // CONFIGURE THE CELL
    // Grab the instance of the programme object from appropriate element of the nth array in the programmeSchedule array
    
    // the section is the nth array, where n is the section number
    NSArray *nthArray = [scheduleArray objectAtIndex:indexPath.section];
    
    // and the programme is the mth element in the nth array, where m is the row
    Programme *p = [nthArray objectAtIndex:indexPath.row];
    //NSLog(@"Section = %d / Row = %d", indexPath.section, indexPath.row);
    //NSLog(@"Programme title = %@", p.title);
    //NSLog(@"Programme timeslot = %d", p.timeSlot);

    // Extract the programme item from the dictionary
    
    // channel (sub-content)
    // title
    // subtitle
    // description
    // duration
    // start
    // end
    // watchers
    
    
    // Configure the cell using built-in labels
    // [[cell textLabel] setText:[p title]];
    // [[cell detailTextLabel] setText:[p blurb]];
    
    // Configure the cell using custom labelling
    
    // Get references to the cell view's labels
    UILabel *titleLabel = PROG_TITLE_LABEL;
    UILabel *descriptionLabel = PROG_DESCRIPTION_LABEL;
    UILabel *channelLabel = PROG_CHANNEL_LABEL;
    UILabel *timeLabel = PROG_TIME_LABEL;
    UILabel *durationLabel = PROG_DURATION_LABEL;
    UILabel *watchersLabel = PROG_WATCHERS_LABEL;
    UIImageView *watchingFlagImage = PROG_WATCHING_FLAG;

    // Configure the programme title
    //titleLabel.numberOfLines=0;
    titleLabel.text = p.title;
    //[titleLabel sizeToFit];
    
    // Configure the programme blurb
    descriptionLabel.text = p.description;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    
    // Configure the channel
    channelLabel.text = [p channel];
    
    // Configure the time label
    timeLabel.text = [p time];
    
    // Configure the duration label
    durationLabel.text = [p duration];
    
    // Configure the watchers label
    watchersLabel.text = [NSString stringWithFormat:@"%d", [p watchers]];
    
    // Set up the cell accessory type
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // If the programme is being watched, set up the watching flag as visible
    if (p.amWatching == TRUE) {
        // Flip the visibility to ON
        watchingFlagImage.hidden = FALSE;
    } else {
        // Need to explicitly state that image should be hidden,
        // otherwise it'll show up if the cell gets reused
        watchingFlagImage.hidden = TRUE;
    }
    
    // return the new cell
    return cell;
    
    // Don't need to release the cell; it was created autoreleased
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the standard row height for the cells
    return 120;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    // Check the timeslot value from the relevant element of the sectionTitlesArray
    return [NSString stringWithFormat:@"%@pm", [sectionTitlesArray objectAtIndex:section]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Grab the current cell for row at index path
    NSMutableArray *nthMutableArray = [scheduleArray objectAtIndex:indexPath.section];
    Programme *p = [nthMutableArray objectAtIndex:indexPath.row];

    // Check whether I'm watching this programme
    if ([p amWatching]) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.85 alpha:1.0];
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Grab the instance of the programme object from appropriate element of the nth array in the programmeSchedule array
    // the section is the nth array, where n is the section number
    NSArray *nthArray = [scheduleArray objectAtIndex:indexPath.section];
    
    // and the programme is the mth element in the nth array, where m is the row
    Programme *p = [nthArray objectAtIndex:indexPath.row];
    
    //NSLog(@"Section = %d / Row = %d", indexPath.section, indexPath.row);
    //NSLog(@"Programme title = %@", p.title);
    //NSLog(@"Programme timeslot = %d", p.timeSlot);
    
    // Do I need to create the instance of ItemDetailController?
	if (!programmeDetailViewController) {
		programmeDetailViewController = [[ProgrammeDetailViewController alloc] init];
	}
    
    // Give the detail view controller a pointer to the programme object at this row
    [programmeDetailViewController setDisplayProgramme:p];
        
    // Pass in the current Twitter engine
    [programmeDetailViewController setTwitterEngine:_engine];
    
    // Push the view controller onto the stack
    [self.navigationController pushViewController:programmeDetailViewController animated:YES];
    
    //[programmeDetailViewController release];
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
	[self.loadPublicTimelineOperation cancel];
	self.loadPublicTimelineOperation.delegate = nil;
}


- (void)dealloc {
	[self.loadPublicTimelineOperation release];
	//[_engine release];
    
    [self.scheduleArray release];
    [self.cleanScheduleArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark LoadPublicTimelineOperationDelegate methods

-(void)loadPublicTimelineOperation:(NSOperation *)theOperation publicTimelineDidLoad:(NSMutableArray *)thePublicTimeline
{
    self.scheduleArray = thePublicTimeline;

    // Grab the first element of the sechedule array, which contains the section titles
    NSArray *sectionTitles = [self.scheduleArray objectAtIndex:0];

    // Create a set to get only the unique values
    NSSet *sectionTitlesSet = [NSSet setWithArray:sectionTitles];
    
    // Now create a temp array from the set and sort it
    NSMutableArray *tempSortedArray = [[NSMutableArray alloc] initWithArray:[sectionTitlesSet allObjects]];
    [tempSortedArray sortUsingSelector:@selector(compare:)];
    
    // Now assign tempSortedArray to sectionTitleSsArray ivar
    sectionTitlesArray = tempSortedArray;
    
    // Remove the first object of the schedule array
    [self.scheduleArray removeObjectAtIndex:0];
    
    // Force a table reload
	[self.tableView reloadData];
    
    if (throbberView) {
        [SVProgressHUD dismiss];
        [self dismissThrobber];
    }
    
    
}

#pragma mark -
#pragma mark WeWatch methods

// Received a didWatchProgramme or didUnwatchProgramme essage via the 
// notification centre, so we need to set the forceDataReload flag to 
// ensure that the data gets refreshed when the view reappears

-(void)didReceiveWatchProgrammeMessage {
    NSLog(@"*** RootViewController didReceiveWatchProgrammeMessage");
    self.forceDataReload = YES;
}

-(void)didReceiveUnwatchProgrammeMessage {
    NSLog(@"*** RootViewController didReceiveUnwatchProgrammeMessage");
    self.forceDataReload = YES;
}

-(void)didReceiveChangeTwitterLoginStatusMessage {
    NSLog(@"*** RootViewController didReceiveChangeTwitterLoginStatusMessage");
    self.forceDataReload = YES;
}

-(void)refresh{
    
    // Refresh method to support pull-to-refresh functionality
    
    NSLog(@"Running refresh method");
    
    // Load public timeline from the web.
	// self.loadPublicTimelineOperation = [[LoadPublicTimelineOperation alloc] init];
    
    // Check if network is reachable
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
        
        NSLog(@"Checking - the username is %@", [_engine username]);

        // Show the modal throbber
        [self showThrobber];
         
        // Fire off the loadPublicTimeline
        self.loadPublicTimelineOperation = [[LoadPublicTimelineOperation alloc] initWithTwitterName:[_engine username]];
        self.loadPublicTimelineOperation.delegate = self;
        //self.loadPublicTimelineOperation.twitterName = [_engine username];
        
        NSOperationQueue *operationQueue = [(WeWatchAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
        [operationQueue addOperation:self.loadPublicTimelineOperation];
  
        [self stopLoading];
        
        NSLog(@"Stopped running refresh");
    }
    else {
        NSLog(@"Not Reachable");
        
        NSString *alertString = [NSString stringWithFormat:@"I couldn't reach WeWatch to retrieve the programme information. Please try later..."];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Sorry!"
                              message: alertString
                              delegate: nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        
        [self stopLoading];
    }
    
    [reachable release];
    
}

-(void)displaySettingsModalWindow {
    NSLog(@"Firing displaySettingsModalWindow");
    
    // Create the modal view controller
    SettingsModalViewController *settingsModalViewController = [[SettingsModalViewController alloc] initWithNibName:@"SettingsModalViewController" bundle:nil];
    settingsModalViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [settingsModalViewController setTwitterEngine:_engine];
    
    // Present the modalViewController with a horizontal flip
    [self presentModalViewController:settingsModalViewController animated:YES];
    [settingsModalViewController release];
    
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
    // We've successfully authenticated against Twitter
	NSLog(@"Successfully authenticated with Twitter as %@", username);
    
    // Update the title of the button bar item
    self.navigationItem.rightBarButtonItem.title = @"Logout";
    
    // Now fire the reload method to pull down an updated watch list
    // This is necessary to ensure that we're displaying the current watching status
    [self refresh];
    
}


//=============================================================================================================================
#pragma mark -
#pragma mark Twitter methods

-(BOOL)checkTwitterLoginStatus {
    
    // Check if the user is already authorised
    // Not going to bother checking if the network is reachable, because
    // the calling function has already done that
        
    // Check if Twitter user is logged in
    if (![_engine isAuthorized]) {
        // They aren't
        return FALSE;
    } else {
        // They are...
        return TRUE;
    }
    
}

-(void)loginToTwitter {
    
    // Check if the user is already authorised
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
        // Able to reach the network, therefore attempt to login via Twitter
        
        if (![self checkTwitterLoginStatus]) {
            
            // There isn't an authorised user, so it makes sense to present the Twitter login page
            // Clear cookies first:
            
            [_engine clearsCookies];
            
            UIViewController *OAuthController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
            
            // If there is a controller present, display the OAuthController's modal window
            if (OAuthController) {
                [self presentModalViewController:OAuthController animated:YES];
            }
            NSLog(@"Finished with oAuth");
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


-(BOOL)sendTweet:(NSString *)tweetText {
    [_engine sendUpdate:tweetText];
    return true;
}

-(void)changeTwitterLoginStatus {
    
    NSLog(@"Firing changeTwitterLoginStatus method");
    
    // Fire Twitter OAuth engine
    if (!_engine) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    
    // Check if the network is reachable or now
    Reachable *reachable = [[Reachable alloc] init];
    
    if ([reachable isReachable]) {
    
        // Able to reach the network, therefore attempt to switch the Twitter login status
       
        if (![self checkTwitterLoginStatus]) {
            
            // NSLog(@"No authorised Twitter user found");
            
            // There isn't an authorised user, so it makes sense to present the Twitter login page
            UIViewController *OAuthController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
            
            // If there is a controller present, display the OAuthController's modal window
            if (OAuthController) {
                [self presentModalViewController:OAuthController animated:YES];
            }
            // NSLog(@"Finished with oAuth");
     
        } else {
            
            // There IS a valid twitter user around
            // As we've found an authorised user, it makes sense to log them out...
            [_engine clearAccessToken];
            [_engine clearsCookies];
            [_engine setUsername:NULL password:NULL];
                                
            // Change the text of the login button
            self.navigationItem.rightBarButtonItem.title = @"Login";
            
            // Refresh the data
            [self refresh];
        
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

-(void)showTwitterUser{
    NSLog(@"Running showTwitterUser method");
    
    // Set up the string with the username in it
    NSString *alertString = [NSString stringWithFormat:@"The current user is %@", [_engine username]];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Settings"
                          message: alertString
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:nil];
    
    [alert addButtonWithTitle:@"Logout"];
    
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) { // Clicked the logout button
        // End the Twitter session
        [_engine clearAccessToken];
    }
}

//=============================================================================================================================
#pragma mark -
#pragma mark TwitterEngineDelegate

- (void)requestSucceeded:(NSString *)requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



@end





