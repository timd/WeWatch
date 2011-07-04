//
//  ProgrammeDetailViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 01/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ProgrammeDetailViewController.h"
#import "Reachable.h"
#import "LoadImage.h"
#import "LoadProgrammeImageOperation.h"
#import "WeWatchAppDelegate.h"


@implementation ProgrammeDetailViewController

@synthesize displayProgramme = _displayProgramme;
@synthesize programmeImage = _programmeImage;

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
    [watchersNamesLabel release];
    [watchingFlag release];
    [reminderButton release];
    [webButton release];
    [commentCountLabel release];
    
    [_displayProgramme release];
    _displayProgramme = nil;
    
    [_programmeImage release];
    _programmeImage = nil;

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
    
    // Register this class so that it can listen out for didWatchProgramme and didUnwatchProgramme notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveWatchProgrammeMessage) 
                                                 name:@"didWatchProgramme" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveUnwatchProgrammeMessage) 
                                                 name:@"didUnwatchProgramme" 
                                               object:nil];
    
    NSLog(@"Firing viewDidLoad");
    
    // Set the label values for the detail view
    [titleLabel setText:[_displayProgramme title]];
    [subtitleLabel setText:[_displayProgramme subtitle]];
    [descriptionLabel setText:[_displayProgramme description]];
    [channelLabel setText:[_displayProgramme channel]];
    [timeLabel setText:[_displayProgramme time]];
    [durationLabel setText:[_displayProgramme duration]];
    [watchersLabel setText:[NSString stringWithFormat:@"%d", [_displayProgramme watchers]]];
    
    // Set up the default image
    [webButton setImage:[UIImage imageNamed:@"wewatch"] forState:UIControlStateNormal];

    // Fire off the asynchronous image load
    [self retrieveImageAsynchronously];
    
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

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Firing viewWillAppear");    
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

-(void)retrieveImageAsynchronously {
    
    // Fire off the asynchronous image retrieval process
    // Check if the network is reachable:
    Reachable *reachable = [[Reachable alloc] init];

    if ([reachable isReachable]) {
        
        NSLog(@"Firing queued image retrieval");
        
        [NSURL URLWithString:[_displayProgramme programmeImage]];
        
        // Fire off loadImage 
        _loadImageOperation = [[LoadImage alloc] initWithProgrammeImageURL:[NSURL URLWithString:[_displayProgramme programmeImage]]];
        
        _loadImageOperation.delegate = self;
        
        // Fire off loadProgrammeImageOperation
        //        self.loadProgrammeImageOperation = [[LoadProgrammeImageOperation alloc] initWithProgrammeImageURL:[NSURL URLWithString:[displayProgramme programmeImage]]];
        
        //        self.loadProgrammeImageOperation.delegate = self;
        
        // Create queue and add retrieval job
        NSOperationQueue *operationQueue = [(WeWatchAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
        [operationQueue addOperation:_loadImageOperation];
        
        NSLog(@"Called queued image retrieval");
        
        // Download the programme image
        // [programmeImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[displayProgramme programmeImage]]]]];
        
    } else {
        // Can't get to the network; use a canned image
        NSLog(@"Unable to download the image");
        // [programmeImage setImage:[UIImage imageWithContentsOfFile:@"wewatch.png"]];
        //        [programmeImage setImage:[UIImage imageNamed:@"wewatch.png"]];
        // [webButton setBackgroundImage:[UIImage imageNamed:@"wewatch.png"] forState:UIControlStateNormal];
    }

    [reachable release];
}

#pragma mark -
#pragma mark Watch notification methods

-(void)didReceiveWatchProgrammeMessage {
    NSLog(@"ProgrammeDetailViewController::didReceiveWatchProgrammeMessage");
    watchingFlag.hidden = NO;
    
    // Update the watchers count by 1
    int watchersCount = [watchersLabel.text intValue]; 
    watchersCount++;
    watchersLabel.text = [NSString stringWithFormat:@"%d", watchersCount];
    
}

-(void)didReceiveUnwatchProgrammeMessage {
    NSLog(@"ProgrammeDetailViewController::didReceiveUnwatchProgrammeMessage");
    // Clean up watching artifacts
    watchingFlag.hidden = YES;    
    
    // Update the watchers count by -1
    int watchersCount = [watchersLabel.text intValue]; 
    watchersCount--;
    watchersLabel.text = [NSString stringWithFormat:@"%d", watchersCount];
}


#pragma mark -
#pragma mark LoadImageDelegate methods

-(void)didLoadImage:(UIImage *)retrievedImage {
    
    NSLog(@"ProgrammeDetailViewController :: didLoadImage method fired");
    // Programme image has been successfully loaded by LoadImage, so set the programme image to the one which was retrieved
    [webButton setImage:retrievedImage forState:UIControlStateNormal];
    
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
