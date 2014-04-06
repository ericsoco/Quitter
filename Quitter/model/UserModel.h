//
//  UserModel.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/30/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject <NSCopying, NSCoding>

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageUrl;
@property (strong, nonatomic) NSString *profileBackgroundImageUrl;
@property (strong, nonatomic) NSNumber *numTweets;
@property (strong, nonatomic) NSNumber *numFollowing;
@property (strong, nonatomic) NSNumber *numFollowers;

+ (UserModel *)initWithJSON:(NSDictionary *)json;

@end
