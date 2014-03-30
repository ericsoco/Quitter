//
//  TweetModel.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *numRetweets;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userScreenName;
@property (strong, nonatomic) NSString *userProfileImageUrl;

+ (TweetModel *)initWithJSON:(NSDictionary *)json;


@end
