//
//  WatchModalViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 03/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "WatchModalViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation WatchModalViewController

@synthesize displayProgramme;
@synthesize providedProgrammeImage;

#pragma mark -
#pragma mark Custom methods

-(IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)watchProgramme{
    
    NSLog(@"Firing the watchProgramme action");

    // Get rid of the keyboard
    [tweetText resignFirstResponder];
    
    // As an interim measure, pop up an alert
    NSString *alertString = [NSString stringWithFormat:@"No built yet..."];
    
    // Set up the string with the username in it
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Watching..."
                          message: alertString
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [self dismissView];
}

- (BOOL)textFieldShouldReturn:(UITextView *)textField {
    [tweetText resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
      {
        [tweetText resignFirstResponder];
        return NO;
      }
    return YES;
}

-(IBAction)resignTextViewFirstResponder {
    [tweetText resignFirstResponder];
}

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
    [durationLabel release];
    [programmeImage release];
    [watchingFlag release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up the tweet textArea
    [tweetText setDelegate:self];
    
    tweetText.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    tweetText.layer.borderColor = [[UIColor grayColor] CGColor];
    tweetText.layer.cornerRadius = 8.0f;
    tweetText.layer.borderWidth = 1.0f;
    tweetText.layer.masksToBounds = YES;
    
    
    
    // Set the label values for the detail view
    [titleLabel setText:[displayProgramme title]];
    [subtitleLabel setText:[displayProgramme subtitle]];
    [channelLabel setText:[displayProgramme channel]];
    [timeLabel setText:[displayProgramme time]];
    [durationLabel setText:[displayProgramme duration]];
    
    // Set the image view to display the image that was passed in
    [programmeImage setImage:providedProgrammeImage];

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