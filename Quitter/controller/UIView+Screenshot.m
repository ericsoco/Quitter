//
//  UIView+Screenshot.m
//  Quitter
//
//  Created by Eric Socolofsky on 4/6/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *)convertViewToImage {
	UIGraphicsBeginImageContext(self.bounds.size);
	[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
