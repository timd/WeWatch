//
//  LoadImagesOperationDelegate.h
//  DrillDown
//
//  Created by Aral Balkan on 22/07/2010.
//  Copyright 2010 Naklab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadImagesOperationDelegate
@required
-(void)loadImagesOperation:(NSOperation *)theImagesOperation didLoadProfileImage:(UIImage *)profileImage andBackgroundImage:(UIImage *)backgroundImage;

@end
