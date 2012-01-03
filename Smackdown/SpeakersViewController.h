//
//  SpeakersViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 1/3/12.
//  Copyright (c) 2012 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeakersViewController : UITableViewController{
  NSFetchedResultsController *fetchController;
}

- (void)cacheSpeakers;
@end
