//
//  TSAppDelegate.m
//  Example
//
//  Created by Felix Krause on 13.04.13.
//  Copyright (c) 2013 Felix Krause. All rights reserved.
//

#import "TSAppDelegate.h"
#import <SQMessages/SQMessageView.h>
@implementation TSAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**
    //If you want you can overidde some properties using UIAppearance
    [[SQMessageView appearance] setTitleFont:[UIFont boldSystemFontOfSize:6]];
    [[SQMessageView appearance] setTitleTextColor:[UIColor redColor]];
    [[SQMessageView appearance] setContentFont:[UIFont boldSystemFontOfSize:10]];
    [[SQMessageView appearance]setContentTextColor:[UIColor greenColor]];
    [[SQMessageView appearance]setErrorIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
    [[SQMessageView appearance]setSuccessIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
    [[SQMessageView appearance]setMessageIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
    [[SQMessageView appearance]setWarningIcon:[UIImage imageNamed:@"NotificationButtonBackground"]];
    //End of override
     */
    return YES;
}

@end 
