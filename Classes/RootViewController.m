//
//  RootViewController.m
//  DrillDown
//
//  Created by Aral Balkan on 21/07/2010.
//  Copyright Naklab 2010. All rights reserved.
//

#import "RootViewController.h"
#import "CJSONDeserializer.h"
#import "TweetDetailViewController.h"
#import "LoadPublicTimelineOperation.h"
#import "DrillDownAppDelegate.h"

@implementation RootViewController

@synthesize tweetsArray;
@synthesize loadPublicTimelineOperation;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.title = @"WeWatch";
	
	// Load public timeline from the web.
	self.loadPublicTimelineOperation = [[LoadPublicTimelineOperation alloc] init];
	self.loadPublicTimelineOperation.delegate = self;
	
	NSOperationQueue *operationQueue = [(DrillDownAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
	[operationQueue addOperation:self.loadPublicTimelineOperation];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
#pragma mark UITableViewDataSource methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NSDictionary *tweetDictionary = [self.tweetsArray objectAtIndex:indexPath.row];
	
    NSString *tweetString = [tweetDictionary objectForKey:@"text"];
	
	//NSDictionary *user = [tweetDictionary objectForKey:@"user"];
	//NSString *userName = [user objectForKey:@"name"];
	
	NSString *userName = [tweetDictionary valueForKeyPath:@"user.name"];
	
	// Play
	
	NSArray *allNames = [self.tweetsArray valueForKeyPath:@"user.name"];
	NSLog(@"All names = %@", allNames);
	
	///////
	
	cell.textLabel.text = tweetString;
	cell.detailTextLabel.text = userName;
						  
    return cell;
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
    
	NSDictionary *tweet = [self.tweetsArray objectAtIndex:indexPath.row];
	
	TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil tweet:tweet];
	
	[self.navigationController pushViewController:tweetDetailViewController animated:YES];
	
	[tweetDetailViewController release];
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
	
    [super dealloc];
}

#pragma mark -
#pragma mark LoadPublicTimelineOperationDelegate methods

-(void)loadPublicTimelineOperation:(NSOperation *)theOperation publicTimelineDidLoad:(NSArray *)thePublicTimeline
{
	NSLog(@"Tweets: %@", thePublicTimeline);
	
	self.tweetsArray = thePublicTimeline;
	
	[self.tableView reloadData];
}

@end





