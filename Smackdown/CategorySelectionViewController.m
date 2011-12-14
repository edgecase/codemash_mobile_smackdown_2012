//
//  CategorySelectionViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "CategorySelectionViewController.h"

@implementation CategorySelectionViewController
@synthesize categories;

- (void)setCategories:(NSArray *)newCats{
  categories = newCats;
  [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return (categories) ? [categories count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
  if(!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"categoryCell"];
  }
  
  NSString *category = [categories objectAtIndex:indexPath.row];
  
  cell.textLabel.text = category;
  return cell;
}

@end
