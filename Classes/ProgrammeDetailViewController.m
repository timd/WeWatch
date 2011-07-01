//
//  ProgrammeDetailViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 01/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ProgrammeDetailViewController.h"


@implementation ProgrammeDetailViewController

@synthesize displayProgramme = _displayProgramme;

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
    [watchersNamesLabel release];
    [watchingFlag release];
    [reminderButton release];
    [webButton release];
    [commentCountLabel release];
    
    [_displayProgramme release];
    _displayProgramme = nil;

    [super dealloc];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the label values for the detail view
    [titleLabel setText:[_displayProgramme title]];
    [subtitleLabel setText:[_displayProgramme subtitle]];
    [descriptionLabel setText:[_displayProgramme description]];
    [channelLabel setText:[_displayProgramme channel]];
    [timeLabel setText:[_displayProgramme time]];
    [durationLabel setText:[_displayProgramme duration]];
    [watchersLabel setText:[NSString stringWithFormat:@"%d", [_displayProgramme watchers]]];
    
    // Extract the names from the watchers names array
    if ([[_displayProgramme watcherNames] count] != 0) {
        
        NSMutableString *watchersNamesLabelText = [[NSMutableString alloc] init];
        
        // there is some content in the watcherNames array
        for (NSString *name in [_displayProgramme watcherNames]) {
            [watchersNamesLabelText appendString:name];
        }
        
        [watchersNamesLabel setText:watchersNamesLabelText];
        
        [watchersNamesLabelText release];
        
    } else {
        [watchersNamesLabel setText:@""];
    }
    
    // Set up the watching flag, depending on whether I'm going to watch the programme or not
    if ([_displayProgramme amWatching] == TRUE) {
        
        // Set the watching flag status
        watchingFlag.hidden = FALSE;
        
    } else {
        
        watchingFlag.hidden = TRUE;
        
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
