//
//  SessionsViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionsViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>{
  Session *selectedSession;

  NSFetchedResultsController *fetchController;
  IBOutlet UIActivityIndicatorView *spinner;
  
  // preloaded ux images.
  UIImage *calendarCheckImage;
  UIImage *calendarUncheckImage;
}

- (void)loadSessions;
- (void)loadRemote:(NSString *)typeOfRemoteEntity;

@end
