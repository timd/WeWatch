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

@implementation RootViewController

@synthesize tweetsArray;
@synthesize cleanScheduleArray;
@synthesize loadPublicTimelineOperation;

@synthesize detailViewController;
@synthesize nibLoadedCell;

// Define custom cell content identifiers
#define PROG_TITLE_LABEL ((UILabel *)[cell viewWithTag:1010])
#define PROG_DESCRIPTION_LABEL ((UILabel *)[cell viewWithTag:1020])
#define PROG_CHANNEL_LABEL ((UILabel *)[cell viewWithTag:1030])
#define PROG_TIME_LABEL ((UILabel *)[cell viewWithTag:1040])
#define PROG_DURATION_LABEL ((UILabel *)[cell viewWithTag:1050])
#define PROG_WATCHERS_LABEL ((UILabel *)[cell viewWithTag:1060])

// Define table section headers
#define HEADING_ARRAY [NSArray arrayWithObjects:@"7pm", @"8pm", @"9pm", @"10pm", nil]



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
	
	NSOperationQueue *operationQueue = [(WeWatchAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
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
    
    // Check for a reusable cell first, and use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProgrammeCell"];
    
    // If there isn't a free cell, then create one
    if (cell == nil) {
        // Create a standard cell
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProgrammeCell"] autorelease];
        
        // Create a custom cell from a nib
        [[NSBundle mainBundle] loadNibNamed:@"BaseCell" owner:self options:NULL];
        cell = nibLoadedCell;
    }
    
/*    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
 
*/
    
    // CONFIGURE THE CELL
    // Grab the instance of the programme object from appropriate element of the nth array in the programmeSchedule array
    
    // the section is the nth array, where n is the section number
    NSMutableArray *nthMutableArray = [tweetsArray objectAtIndex:indexPath.section];
    
    // Sort the nthArray so that it's in channel order
    //NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"Programme.channel" ascending:YES];
    //[nthMutableArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    // and the programme is the mth element in the nth array, where m is the row
    Programme *p = [nthMutableArray objectAtIndex:indexPath.row];
    NSLog(@"Section = %d / Row = %d", indexPath.section, indexPath.row);
    NSLog(@"Programme title = %@", p.title);
    NSLog(@"Programme timeslot = %d", p.timeSlot);

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

    // Configure the programme title
    titleLabel.text = p.title;
    
    // Configure the programme blurb
    descriptionLabel.text = p.description;
    
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
    
    // return the new cell
    return cell;
    
    // Don't need to release the cell; it was created autoreleased
    
/*
 
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
*/ 
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the standard row height for the cells
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@", [HEADING_ARRAY objectAtIndex:section]];
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
    NSArray *nthArray = [tweetsArray objectAtIndex:indexPath.section];
    
    // and the programme is the mth element in the nth array, where m is the row
    Programme *p = [nthArray objectAtIndex:indexPath.row];
    
    NSLog(@"Section = %d / Row = %d", indexPath.section, indexPath.row);
    NSLog(@"Programme title = %@", p.title);
    NSLog(@"Programme timeslot = %d", p.timeSlot);
    
    // Do I need to create the instance of ItemDetailController?
	if (!programmeDetailViewController) {
		programmeDetailViewController = [[ProgrammeDetailViewController alloc] init];
	}
    
    // Give the detail view controller a pointer to the programme object at this row
    [programmeDetailViewController setDisplayProgramme:p];
/*    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
	[label setFont:[UIFont boldSystemFontOfSize:16.0]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor whiteColor]];
	[label setText:[NSString stringWithFormat:@"%@ %@", p.channel,p.time]];
    
	[self.navigationController.navigationBar.topItem setTitleView:label];
	[label release];
*/
    
    // Push the view controller onto the stack
    [self.navigationController pushViewController:programmeDetailViewController animated:YES];
    
    //[programmeDetailViewController release];
    
    /*
     NSDictionary *tweet = [self.tweetsArray objectAtIndex:indexPath.row];
     
     TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil tweet:tweet];
     
     [self.navigationController pushViewController:tweetDetailViewController animated:YES];
     
     [tweetDetailViewController release];
     */
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





