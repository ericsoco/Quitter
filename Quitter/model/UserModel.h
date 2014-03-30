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

+ (UserModel *)initWithJSON:(NSDictionary *)json;

@end
