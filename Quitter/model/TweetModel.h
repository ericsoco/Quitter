//
//  TweetModel.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface TweetModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *numRetweets;
@property (strong, nonatomic) NSNumber *numFavorites;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) UserModel *retweeter;
@property (strong, nonatomic) NSDate *datestamp;
@property (strong, nonatomic) NSString *shortDateStr;
@property (strong, nonatomic) NSString *longDateStr;
@property (assign, nonatomic) BOOL favoritedByMe;
@property (assign, nonatomic) BOOL retweetedByMe;

+ (TweetModel *)initWithJSON:(NSDictionary *)json;


@end
