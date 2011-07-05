//
//  CommentsTableViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 04/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "CustomCell.h"


@implementation CommentsTableViewController

@synthesize commentsArray = _commentsArray;

// Define custom cell content identifiers
#define COMMENT_NAME_LABEL ((UILabel *)[cell viewWithTag:1010])
#define COMMENT_TEXT_LABEL ((UILabel *)[cell viewWithTag:1020])


#pragma mark -
#pragma Initialisation methods


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    NSLog(@"CommentsTableCV viewDidLoad");
    
    self.tableView.backgroundColor = [UIColor clearColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [_commentsArray release];
    _commentsArray = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection = %d", [_commentsArray count]);
    return [_commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    
    // Get the comment element for the current row
    NSArray *commentElement = [_commentsArray objectAtIndex:indexPath.row];

    // Extract the username and comment
    NSString *username = [[commentElement valueForKey:@"user"] valueForKey:@"username"];
    NSString *commentString = [commentElement valueForKey:@"comment"];
    
    // Get the padded string
    NSString *paddedCommentString = [self spacePaddedStringForUsername:username andComment:commentString];
    
    // Create a UILabel for the comment
    UILabel *commentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 25)] autorelease];
    [commentLabel setLineBreakMode:UILineBreakModeWordWrap];
    [commentLabel setNumberOfLines:0];
    [commentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [commentLabel setTextColor:[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.0]];
    [commentLabel setBackgroundColor:[UIColor clearColor]];
    [commentLabel setText:paddedCommentString];
    
    // Calculate the height of the comment label
    CGSize expectedLabelSize = [self heightForLabelWithText:paddedCommentString andFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    
    // Create a frame for the comment label
    CGRect commentLabelFrame = commentLabel.frame;
    commentLabelFrame.size.height = expectedLabelSize.height;
    commentLabel.frame = commentLabelFrame;
                                
    // Create a UILabel for the name
    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)] autorelease];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:username];
    [nameLabel sizeToFit];
    
    // Add the labels to the cell's view
    [cell.contentView addSubview:commentLabel];
    [cell.contentView addSubview:nameLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    // Get the comment element for the current row
    NSArray *commentElement = [_commentsArray objectAtIndex:indexPath.row];
    
    // Extract the username and comment
    NSString *username = [[commentElement valueForKey:@"user"] valueForKey:@"username"];
    NSString *commentString = [commentElement valueForKey:@"comment"];
    
    // Get the padded comment string
    NSString *paddedCommentString = [self spacePaddedStringForUsername:username andComment:commentString];

    // Calculate the height of the comment label
    CGSize expectedLabelSize = [self heightForLabelWithText:paddedCommentString andFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    
    // Return the height of the expected label size, plus some padding
    return expectedLabelSize.height + 10.0f;
    
}


- (NSString *)spacePaddedStringForUsername:(NSString *)username andComment:(NSString *)theComment {
    
    // Set up padding for name
    float namePadding = 5.0f;
    
    //  calculate the length of the username
    float nameWidth = [username sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]].width + namePadding;
    
    // Calculate the width of the the average space
    float tenSpaceWidth = [[NSString stringWithFormat:@"          "] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]].width;
    float oneSpaceWidth = tenSpaceWidth / 10;
    
    // Calculate the width of the name & add in 1 space-worth of padding
    float nameWidthInFractionalSpaces = nameWidth / oneSpaceWidth;
    int nameWidthInSpaces = (int)(nameWidthInFractionalSpaces + 0.5 );
    
    NSMutableString *paddingString = [[NSMutableString alloc] init];
    // Create a padding string with the requisite number of spaces
    for (int i = 0; i < nameWidthInSpaces; i++) {
        [paddingString appendString:@" "];
    }
    
    // Create padded comment string
    NSString *paddedCommentString = [NSString stringWithFormat:@"%@%@", paddingString, theComment];
    [paddingString release];
    
    // Pass the padded comment string back
    return paddedCommentString ;

}

-(CGSize)heightForLabelWithText:(NSString *)labelText andFont:(UIFont *)theFont {
    
    CGSize maxLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [labelText sizeWithFont:theFont constrainedToSize:maxLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    return expectedLabelSize;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - 
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
