//
//  PrecompilerViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/15/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrecompilerViewController : UITableViewController{  
  NSArray *sessions;
  IBOutlet UIActivityIndicatorView *spinner;
  NSString *sessionsPath;
}

- (void)loadSessions;

@end
