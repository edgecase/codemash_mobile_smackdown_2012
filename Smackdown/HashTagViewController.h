//
//  HashTagViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/15/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HashTagViewController : UITableViewController{
  NSArray *tweets;
  NSMutableDictionary *avatars;
  BOOL canRefresh;
}

@end
