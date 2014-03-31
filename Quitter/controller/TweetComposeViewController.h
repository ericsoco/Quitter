//
//  TweetComposeViewController.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@class TweetComposeViewController;
@protocol TweetComposeDelegate <NSObject>

- (void)tweetComposeViewController:(TweetComposeViewController *)tweetComposeViewController didComposeTweet:(TweetModel *)tweetModel;

@end

@interface TweetComposeViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) id <TweetComposeDelegate> delegate;

- (id)initWithTweetModel:(TweetModel *)model;

@end
