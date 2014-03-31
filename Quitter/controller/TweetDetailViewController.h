//
//  TweetDetailViewController.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"
#import "TweetComposeViewController.h"

@interface TweetDetailViewController : UIViewController <TweetComposeDelegate>

- (id)initWithTweetModel:(TweetModel *)model;

@end
