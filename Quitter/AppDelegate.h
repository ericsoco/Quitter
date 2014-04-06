//
//  AppDelegate.h
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MainMenuDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
