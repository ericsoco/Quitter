//
//  TwitterClient.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "UserModel.h"
#import "TweetModel.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

@property (strong, nonatomic) UserModel *authorizedUser;

- (void)authorizeApp;
- (void)fetchAccountCredentialsWithSuccess:(void (^)(UserModel *userModel))success;

- (void)fetchHomeTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success;
- (void)fetchMentionsTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success;
- (void)fetchRetweetsTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success;
- (void)fetchUserTimelineWithUserId:(NSString *)userId success:(void (^)(NSMutableArray *tweetModels))success;

- (void)postTweetWithModel:(TweetModel *)tweetModel success:(void (^)(NSDictionary *response))success;
- (void)retweetTweetWithId:(NSString *)tweetId success:(void (^)(NSDictionary *response))success;
- (void)deleteTweetWithId:(NSString *)tweetId;
- (void)favoriteTweetWithId:(NSString *)tweetId;
- (void)unfavoriteTweetWithId:(NSString *)tweetId;

@end
