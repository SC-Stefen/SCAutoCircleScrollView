//
//  AppDelegate.h
//  SCAutoCircleScrollViewDemo
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 sc-ici. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

