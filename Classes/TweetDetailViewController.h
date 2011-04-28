//
//  TweetDetailViewController.h
//  DrillDown
//
//  Created by Aral Balkan on 21/07/2010.
//  Copyright 2010 Naklab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadImagesOperationDelegate.h"

@class LoadImagesOperation;

@interface TweetDetailViewController : UIViewController <LoadImagesOperationDelegate> {
	UILabel *nameLabel;
	UIImageView *backgroundImageView;
	UITextView *descriptionView;
	UILabel *followersCount;
	UILabel *followingCount;
	UITextView *latestTweet;
	UIImageView *profileImageView;
	UILabel *screenName;
	LoadImagesOperation *loadImagesOperation;
	
}
@property (nonatomic, retain) LoadImagesOperation *loadImagesOperation;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UITextView *descriptionView;
@property (nonatomic, retain) IBOutlet UILabel *followersCount;
@property (nonatomic, retain) IBOutlet UILabel *followingCount;
@property (nonatomic, retain) IBOutlet UITextView *latestTweet;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *screenName;


@property (nonatomic, retain) NSDictionary *tweet;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tweet:(NSDictionary *)theTweet;




@end
