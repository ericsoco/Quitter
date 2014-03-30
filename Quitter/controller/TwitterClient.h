//
//  TwitterClient.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "UserModel.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

@property (strong, nonatomic) UserModel *authorizedUser;

- (void)authorizeApp;
- (void)fetchHomeTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success;
- (void)fetchAccountCredentials:(void (^)(UserModel *userModel))success;

@end
