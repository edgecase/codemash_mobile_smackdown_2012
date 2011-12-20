//
//  SessionsViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "SessionsViewController.h"
#import "SessionViewController.h"
#import "CategorySelectionViewController.h"
#import "SessionsTableViewCell.h"

@implementation SessionsViewController

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)preloadImages{
  calendarCheckImage = [UIImage imageNamed:@"calendar_checked"];
  calendarUncheckImage = [UIImage imageNamed:@"calendar_unchecked"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
  [super viewDidLoad];
  agenda = [Agenda sharedAgenda];
  [self preloadImages];
  [self loadSessions];
}

- (void)loadSessions{
  if(!sessions){
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Session"];
    
    NSError *err = nil;
    NSArray *results = [[[LGAppDelegate sharedAppDelegate] managedObjectContext] 
                        executeFetchRequest:fetch error:&err];
    
    if(!results || [results count] == 0){ 
      [self loadRemote:@"Session"];
      [self loadRemote:@"Precompiler"];
    } else {
      sessions = results;
      [self.tableView reloadData];
    }
  } 
}

- (void)loadRemote:(NSString *)typeOfRemoteEntity{
  NSURL *sessionURL = nil;
  if([typeOfRemoteEntity isEqualToString:@"Session"]){
    sessionURL = [NSURL URLWithString:@"http://codemash.org/rest/sessions.json"]; 
  } else {
    sessionURL = [NSURL URLWithString:@"http://codemash.org/rest/precompiler.json"];
  }
  NSURLRequest *req = [NSURLRequest requestWithURL:sessionURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:2];
  [NSURLConnection sendAsynchronousRequest:req 
                                     queue:[NSOperationQueue currentQueue]
                         completionHandler:
   ^(NSURLResponse *resp, NSData *data, NSError *err) {
     if(err){
       [spinner stopAnimating];
       [[[UIAlertView alloc] initWithTitle:@"Oh noes!" 
                                   message:[err description] 
                                  delegate:nil 
                         cancelButtonTitle:@"ok" 
                         otherButtonTitles:nil]
        show];
     } else {
       [spinner startAnimating];
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
         NSError *jsonErr = nil;
         NSArray *sessionDics = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonErr];
         NSMutableArray *ts = [NSMutableArray arrayWithCapacity:[sessionDics count]];
         for(NSMutableDictionary *dic in sessionDics){
           Session *obj = [Session createObjectOfType:@"Session" Attributes:dic];
           [obj dateProperty];
           obj.isPrecompiler = ([typeOfRemoteEntity isEqualToString:@"Precompiler"]);
           [ts addObject:obj];
         }
         [ts addObjectsFromArray:sessions];
         sessions = [NSArray arrayWithArray:ts];
         [[LGAppDelegate sharedAppDelegate] saveContext:self];
         dispatch_async(dispatch_get_main_queue(), ^{
           if(!jsonErr) [self.tableView reloadData];
           [spinner stopAnimating];
         });
       });
     }
   }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[self dataInSection:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  switch (section) {
    case 0:
      return @"Precompiler";
      break;
      
    default:
      return @"Sessions";
      break;
  }
}

- (NSArray *)dataInSection:(NSInteger)section{
  switch (section) {
    case 0:
      return [sessions filteredArrayUsingPredicate:
       [NSPredicate predicateWithFormat:@"isPrecompiler = %@", [NSNumber numberWithBool:YES]]];
      break;
    
    case 1:
      return [sessions filteredArrayUsingPredicate:
              [NSPredicate predicateWithFormat:@"isPrecompiler = %@", [NSNumber numberWithBool:NO]]];
      break;
    default:
      return [NSArray array];
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  SessionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
  if(!cell){
    cell = (SessionsTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];
  }
  
  Session *session = [[self dataInSection:indexPath.section] objectAtIndex:indexPath.row];

  cell.titleView.text = [session valueForKeyPath:@"properties.Title"];
  cell.detailView.text = 
  [NSString stringWithFormat:@"%@ - %@",
   [session valueForKeyPath:@"properties.Technology"],
   [session dateProperty]];

  cell.checkboxView.image = ([Agenda isAttendingSession:session]) ? calendarCheckImage : calendarUncheckImage;
  cell.difficultyView.image = [UIImage imageNamed:[[session valueForKeyPath:@"properties.Difficulty"] lowercaseString]];
    
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self performSegueWithIdentifier:@"showSessionDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"showSessionDetails"]){
    SessionViewController *sessionController = (SessionViewController *)[segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    sessionController.session = [[self dataInSection:indexPath.section] objectAtIndex:indexPath.row];

  } else if([[segue identifier] isEqualToString:@"showCategorySelection"]){
    CategorySelectionViewController *catController = (CategorySelectionViewController *)[segue destinationViewController];
    catController.categories = 
    [sessions valueForKeyPath:@"properties.@distinctUnionOfObjects.Technology"];
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (editingStyle == UITableViewCellEditingStyleDelete){
    Session *session = [[self dataInSection:indexPath.section] objectAtIndex:indexPath.row];
    BOOL isAttending = [Agenda isAttendingSession:session];

    if(isAttending)
      [agenda doNotAttendSession:session];
    else 
      [agenda attendSession:session];
    
    [[LGAppDelegate sharedAppDelegate] saveContext:self];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  Session *session = [sessions objectAtIndex:indexPath.row];
  
  BOOL isAttending = [Agenda isAttendingSession:session];
  return (isAttending) ? @"don't attend" : @"attend";
}

@end
