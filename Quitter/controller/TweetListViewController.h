//
//  TweetListViewController.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetComposeViewController.h"
#import "TweetViewCell.h"

@interface TweetListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetComposeDelegate, TweetViewCellDelegate>

typedef NS_ENUM(NSInteger, TweetListType) {
	TweetListTypeHome,
	TweetListTypeMentions,
	TweetListTypeRetweets
};

- (id)initWithTweetListType:(TweetListType)tweetListType;
- (void)displayTweets;

@end
