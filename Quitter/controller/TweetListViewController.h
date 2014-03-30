//
//  TweetListViewController.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetComposeViewController.h"

@interface TweetListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetComposeDelegate>

- (void)displayUserTweets;

@end
