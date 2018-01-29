//
//  SQMessagesTests.m
//  SQMessagesTests
//
//  Created by Felix Krause on 08/25/2014.
//  Copyright (c) 2014 Felix Krause. All rights reserved.
//

#import "SQMessage.h"
#import "SQMessageView.h"

SpecBegin(InitialSpecs)

describe(@"Show a new SQMessage notification", ^{
    before(^{
        [UIView setAnimationsEnabled:NO];
        [SQMessage dismissActiveNotification];
    });
    
    it(@"matches view (error message)", ^{
        [SQMessage showNotificationWithTitle:@"Error" type:SQMessageNotificationTypeError];
        SQMessageView *view = [[SQMessage queuedMessages] lastObject];
        
        expect(view).to.haveValidSnapshotNamed(@"SQMessageViewErrorDefault");
    });
});

SpecEnd
