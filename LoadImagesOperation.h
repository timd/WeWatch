//
//  LoadImagesOperation.h
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadImagesOperationDelegate.h"

@interface LoadImagesOperation : NSOperation {
	id <LoadImagesOperationDelegate> delegate;
	NSDictionary *tweet;
}

@property (nonatomic, assign) id <LoadImagesOperationDelegate> delegate;
@property (nonatomic, retain) NSDictionary *tweet;

-(UIImage *)loadImageForKeyPath:(NSString *)keyPath;

@end
