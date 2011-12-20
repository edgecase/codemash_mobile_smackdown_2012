//
//  SessionsTableViewCell.h
//  Smackdown
//
//  Created by Leon Gersing on 12/19/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionsTableViewCell : UITableViewCell{
  IBOutlet UIImageView *checkboxView;
  IBOutlet UIImageView *difficultyView;
  IBOutlet UILabel *titleView;
  IBOutlet UILabel *detailView;
}

@property (nonatomic, retain) UIImageView *checkboxView;
@property (nonatomic, retain) UIImageView *difficultyView;
@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *detailView;


@end
