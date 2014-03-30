//
//  TweetViewCell.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface TweetViewCell : UITableViewCell

- (void)initWithModel:(TweetModel *)model;
- (CGFloat)calcHeightWithModel:(TweetModel *)model;

@end
