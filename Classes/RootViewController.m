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

#import "Programme.h"

@implementation RootViewController

@synthesize tweetsArray;
@synthesize cleanScheduleArray;
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
    
    // Number of sections is dependent on the number of timeslot arrays in the cleanScheduleArray
    
    NSLog(@"There are %d sections in tweetsArray", [tweetsArray count]);
    return [tweetsArray count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // This depends on which section we're dealing with (numbered from 0 to n)
    // The rows come from the number of elements in the nth array in the programmeSchedule array
    
    // Get the nth array from programmeSchedule
    NSArray *nthElement = [tweetsArray objectAtIndex:section];
    
    NSLog(@"There are %d rows in section %d", [nthElement count], section);
    
    // Count how many elements are in this nth array, and return it
    return [nthElement count];    
    
    //return [self.tweetsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    NSArray *nthElement = [self.tweetsArray objectAtIndex:indexPath.section];
    
	Programme *p = [nthElement objectAtIndex:indexPath.row];
    
    NSLog(@"object = %@", p);
	
    NSString *tweetString = p.title;

    // NSString *tweetString = [programmeDictionary objectForKey:@"title"];
	
	//NSDictionary *user = [tweetDictionary objectForKey:@"user"];
	//NSString *userName = [user objectForKey:@"name"];
	
	// NSString *userName = [tweetDictionary valueForKeyPath:@"user.name"];
	
	// Play
	
	//NSArray *allNames = [self.tweetsArray valueForKeyPath:@"user.name"];
	//NSLog(@"All names = %@", allNames);
	
	///////
	
	cell.textLabel.text = tweetString;
	//cell.detailTextLabel.text = userName;
						  
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





