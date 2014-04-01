//
//  TweetViewCell.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@class TweetViewCell;
@protocol TweetViewCellDelegate <NSObject>

- (void)tweetViewCell:(TweetViewCell *)tweetViewCell replyWasTapped:(id)sender;
- (void)tweetViewCell:(TweetViewCell *)tweetViewCell retweetWasTapped:(id)sender;
- (void)tweetViewCell:(TweetViewCell *)tweetViewCell favoriteWasTapped:(id)sender;

@end

@interface TweetViewCell : UITableViewCell

@property (strong, nonatomic) id<TweetViewCellDelegate> delegate;

- (void)initWithModel:(TweetModel *)model;
- (CGFloat)calcHeightWithModel:(TweetModel *)model;

@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL favorited;

@end
