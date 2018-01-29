//
//  TSSecondViewController.m
//  Example
//
//  Created by Felix Krause on 13.04.13.
//  Copyright (c) 2013 Felix Krause. All rights reserved.
//


#import "TSDemoViewController.h"
#import "SQMessage.h"
#import "SQMessageView.h"

@implementation TSDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SQMessage setDefaultViewController:self];
    [SQMessage setDelegate:self];
    self.wantsFullScreenLayout = YES;
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (IBAction)didTapError:(id)sender
{
    [SQMessage showNotificationWithTitle:NSLocalizedString(@"Something failed", nil)
                                subtitle:NSLocalizedString(@"The internet connection seems to be down. Please check that!", nil)
                                    type:SQMessageNotificationTypeError];
}

- (IBAction)didTapWarning:(id)sender
{
    [SQMessage showNotificationWithTitle:NSLocalizedString(@"Some random warning", nil)
                                subtitle:NSLocalizedString(@"Look out! Something is happening there!", nil)
                                    type:SQMessageNotificationTypeWarning];
}

- (IBAction)didTapMessage:(id)sender
{
    [SQMessage showNotificationWithTitle:NSLocalizedString(@"Tell the user something", nil)
                                subtitle:NSLocalizedString(@"This is some neutral notification!", nil)
                                    type:SQMessageNotificationTypeMessage];
}

- (IBAction)didTapSuccess:(id)sender
{
    [SQMessage showNotificationWithTitle:NSLocalizedString(@"Success", nil)
                                subtitle:NSLocalizedString(@"Some task was successfully completed!", nil)
                                    type:SQMessageNotificationTypeSuccess];
}

- (IBAction)didTapButton:(id)sender
{
    [SQMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"New version available", nil)
                                       subtitle:NSLocalizedString(@"Please update our app. We would be very thankful", nil)
                                          image:nil
                                           type:SQMessageNotificationTypeMessage
                                       duration:SQMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:NSLocalizedString(@"Update", nil)
                                 buttonCallback:^{
                                     [SQMessage showNotificationWithTitle:NSLocalizedString(@"Thanks for updating", nil)
                                                                     type:SQMessageNotificationTypeSuccess];
                                 }
                                     atPosition:SQMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

- (IBAction)didTapToggleNavigationBar:(id)sender
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (IBAction)didTapToggleNavigationBarAlpha:(id)sender
{
    CGFloat alpha = self.navigationController.navigationBar.alpha;
    self.navigationController.navigationBar.alpha = (alpha==1.f)?0.5:1;
}

- (IBAction)didTapToggleWantsFullscreen:(id)sender
{
    self.wantsFullScreenLayout = !self.wantsFullScreenLayout;
    [self.navigationController.navigationBar setTranslucent:!self.navigationController.navigationBar.isTranslucent];
}

- (IBAction)didTapCustomImage:(id)sender
{
    [SQMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Custom image", nil)
                                       subtitle:NSLocalizedString(@"This uses an image you can define", nil)
                                          image:[UIImage imageNamed:@"NotificationButtonBackground.png"]
                                           type:SQMessageNotificationTypeMessage
                                       duration:SQMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:SQMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

- (IBAction)didTapDismissCurrentMessage:(id)sender
{
    [SQMessage dismissActiveNotification];
}

- (IBAction)didTapEndless:(id)sender
{
    [SQMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Endless", nil)
                                       subtitle:NSLocalizedString(@"This message can not be dismissed and will not be hidden automatically. Tap the 'Dismiss' button to dismiss the currently shown message", nil)
                                          image:nil
                                           type:SQMessageNotificationTypeSuccess
                                       duration:SQMessageNotificationDurationEndless
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:SQMessageNotificationPositionTop
                            canBeDismissedByUser:NO];
}

- (IBAction)didTapLong:(id)sender
{
    [SQMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Long", nil)
                                       subtitle:NSLocalizedString(@"This message is displayed 10 seconds instead of the calculated value", nil)
                                          image:nil
                                           type:SQMessageNotificationTypeWarning
                                       duration:10.0
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:SQMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

- (IBAction)didTapBottom:(id)sender
{
    [SQMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Hu!", nil)
                                       subtitle:NSLocalizedString(@"I'm down here :)", nil)
                                          image:nil
                                           type:SQMessageNotificationTypeSuccess
                                       duration:SQMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:SQMessageNotificationPositionBottom
                            canBeDismissedByUser:YES];
}

- (IBAction)didTapText:(id)sender
{
    [SQMessage showNotificationWithTitle:NSLocalizedString(@"With 'Text' I meant a long text, so here it is", nil)
                                subtitle:NSLocalizedString(@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus", nil)
                                    type:SQMessageNotificationTypeWarning];
}

- (IBAction)didTapCustomDesign:(id)sender
{
    // this is an example on how to apply a custom design
    [SQMessage addCustomDesignFromFileWithName:@"AlternativeDesign.json"];
    [SQMessage showNotificationWithTitle:NSLocalizedString(@"Updated to custom design file", nil)
                                    subtitle:NSLocalizedString(@"From now on, all the titles of success messages are larger", nil)
                                    type:SQMessageNotificationTypeSuccess];
}


- (IBAction)didTapNavBarOverlay:(id)sender
{
    if (self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    [SQMessage showNotificationInViewController:self.navigationController
                                          title:NSLocalizedString(@"Whoa!", nil)
                                       subtitle:NSLocalizedString(@"Over the Navigation Bar!", nil)
                                          image:nil
                                           type:SQMessageNotificationTypeSuccess
                                       duration:SQMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:SQMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}



//- (CGFloat)messageLocationOfMessageView:(SQMessageView *)messageView
//{
//    return 44.0; // any calculation here
//}

//- (void)customizeMessageView:(SQMessageView *)messageView
//{
//    messageView.alpha = 0.5;
//}

- (IBAction)didTapNavbarHidden:(id)sender
{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}
@end
