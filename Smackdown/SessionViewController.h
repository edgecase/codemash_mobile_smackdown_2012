//
//  SessionViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Speaker.h"
#import "Session.h"

@interface SessionViewController : UITableViewController

@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) Speaker *speaker;

- (IBAction)tweetSessionComment:(id)sender;

@end
