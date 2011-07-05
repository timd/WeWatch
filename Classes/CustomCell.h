//
//  CustomCell.h
//  WeWatch
//
//  Created by Tim Duckett on 05/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
    
    UILabel *userName;
    UILabel *commentText;
    
}

@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UILabel *commentText;

-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
