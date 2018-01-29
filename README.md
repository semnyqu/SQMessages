**Notice: SQMessages is no longer being maintained/updated. We recommend everyone migrate to [RMessage](https://github.com/donileo/RMessage).**

**If you currently rely on the ability to embed a UIButton in SQMessages feel free to continue using SQMessages as you see fit until RMessage implements this feature.**

**This repository will be kept as is for those who want to continue using SQMessages or are in the process of migrating. If an issue you submitted to SQMessages still applies to RMessage feel free to create a new issue in RMessage's repository.**

**If your project is Swift based, you might want to check out [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages), which offers the same features, but is written completely in Swift**

SQMessages
==========

This library provides an easy to use class to show little notification views on the top of the screen. (à la Tweetbot).

[![Twitter: @KauseFx](https://img.shields.io/badge/contact-@KrauseFx-blue.svg?style=flat)](https://twitter.com/KrauseFx)
[![Version](https://img.shields.io/cocoapods/v/SQMessages.svg?style=flat)](http://cocoadocs.org/docsets/SQMessages)
[![License](https://img.shields.io/cocoapods/l/SQMessages.svg?style=flat)](http://cocoadocs.org/docsets/SQMessages)
[![Platform](https://img.shields.io/cocoapods/p/SQMessages.svg?style=flat)](http://cocoadocs.org/docsets/SQMessages)

The notification moves from the top of the screen underneath the navigation bar and stays there for a few seconds, depending on the length of the displayed text. To dismiss a notification before the time runs out, the user can swipe it to the top or just tap it.

There are 4 different types already set up for you: Success, Error, Warning, Message (take a look at the screenshots)

It is very easy to add new notification types with a different design. Add the new type to the notificationType enum, add the needed design properties to the configuration file and set the name of the theme (used in the config file and images) in SQMessagesView.m inside the switch case.

**Take a look at the Example project to see how to use this library.** You have to open the workspace, not the project file, since the Example project uses cocoapods.

Get in contact with the developer on Twitter: [KrauseFx](https://twitter.com/KrauseFx) (Felix Krause)

# Installation

## From CocoaPods
SQMessages is available through [CocoaPods](https://cocoapods.org/). To install
it, simply add the following line to your Podfile:

    pod "SQMessages"
    
## Manually
Copy the source files SQMessageView and SQMessage into your project. Also copy the SQMessagesDesignDefault.json.

# Usage

To show notifications use the following code:

```objective-c
    [SQMessage showNotificationWithTitle:@"Your Title"
                                subtitle:@"A description"
                                    type:SQMessageNotificationTypeError];


    // Add a button inside the message
    [SQMessage showNotificationInViewController:self
                                          title:@"Update available"
                                       subtitle:@"Please update the app"
                                          image:nil
                                           type:SQMessageNotificationTypeMessage
                                       duration:SQMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:@"Update"
                                 buttonCallback:^{
                                     NSLog(@"User tapped the button");
                                 }
                                     atPosition:SQMessageNotificationPositionTop
                           canBeDismissedByUser:YES];


    // Use a custom design file
    [SQMessage addCustomDesignFromFileWithName:@"AlternativeDesign.json"];
```

You can define a default view controller in which the notifications should be displayed:
```objective-c
   [SQMessage setDefaultViewController:myNavController];
```

You can define a default view controller in which the notifications should be displayed:
```objective-c
   [SQMessage setDelegate:self];
   
   ...
   
   - (CGFloat)messageLocationOfMessageView:(SQMessageView *)messageView
   {
    return messageView.viewController...; // any calculation here
   }
```

You can customize a message view, right before it's displayed, like setting an alpha value, or adding a custom subview
```objective-c
   [SQMessage setDelegate:self];
   
   ...
   
   - (void)customizeMessageView:(SQMessageView *)messageView
   {
      messageView.alpha = 0.4;
      [messageView addSubview:...];
   }
```

You can customize message view elements using UIAppearance
```objective-c
#import <SQMessages/SQMessageView.h>
@implementation TSAppDelegate
....

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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

return YES;
}
```



The following properties can be set when creating a new notification:

* **viewController**: The view controller to show the notification in. This might be the navigation controller.
* **title**: The title of the notification view
* **subtitle**: The text that is displayed underneath the title (optional)
* **image**: A custom icon image that is used instead of the default one (optional)
* **type**: The notification type (Message, Warning, Error, Success)
* **duration**: The duration the notification should be displayed
* **callback**: The block that should be executed, when the user dismissed the message by tapping on it or swiping it to the top.

Except the title and the notification type, all of the listed values are optional

If you don't want a detailed description (the text underneath the title) you don't need to set one. The notification will automatically resize itself properly. 

## Screenshots

**iOS 7 Design**

![iOS 7 Error](http://www.toursprung.com/wp-content/uploads/2013/09/error_ios7.png)

![iOS 7 Message](http://www.toursprung.com/wp-content/uploads/2013/09/warning_ios7.png)

**iOS 6 Design**

![Warning](http://www.toursprung.com/wp-content/uploads/2013/04/iNotificationWarning.png)

![Success](http://www.toursprung.com/wp-content/uploads/2013/04/iNotificationSuccess.png)

![Error](http://www.toursprung.com/wp-content/uploads/2013/04/iNotificationError.png)

![Message](http://www.toursprung.com/wp-content/uploads/2013/04/iNotificationMessage.png)


# License
SQMessages is available under the MIT license. See the LICENSE file for more information.

# Recent Changes
Can be found in the [releases section](https://github.com/KrauseFx/SQMessages/releases) of this repo.
