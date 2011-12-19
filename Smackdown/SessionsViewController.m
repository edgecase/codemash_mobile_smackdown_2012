//
//  SessionsViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//



#define TITLE_TAG 10
#define SPEAKER_TAG 11
#define CATEGORY_TAG 12

#import "SessionsViewController.h"
#import "SessionViewController.h"
#import "CategorySelectionViewController.h"

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
  [super viewDidLoad];
  agenda = [Agenda sharedAgenda];
  [self loadSessions];
}

- (void)loadSessions{
  if(!sessions){
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Session"];
    
    NSError *err = nil;
    NSArray *results = [[[LGAppDelegate sharedAppDelegate] managedObjectContext] 
                        executeFetchRequest:fetch error:&err];
    
    if(!results || [results count] == 0){ 
      NSURL *sessionURL = [NSURL URLWithString:@"http://codemash.org/rest/sessions.json"];
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
               [ts addObject:[Session sessionWithAttributes:dic]];
             }
             sessions = [NSArray arrayWithArray:ts];
             [[LGAppDelegate sharedAppDelegate] saveContext:self];
             dispatch_async(dispatch_get_main_queue(), ^{
               if(!jsonErr) [self.tableView reloadData];
               [spinner stopAnimating];
             });
           });
         }
       }];
    } else {
      sessions = results;
      [self.tableView reloadData];
    }
  } 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return (sessions) ? [sessions count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
  if(!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];
  }
  
  Session *session = [sessions objectAtIndex:indexPath.row];
  
  [[cell viewWithTag:TITLE_TAG] setValue:session.title forKeyPath:@"text"];
  [[cell viewWithTag:SPEAKER_TAG] setValue:session.speakerName forKeyPath:@"text"];
  [[cell viewWithTag:CATEGORY_TAG] setValue:session.technology forKeyPath:@"text"];
  
  if([Agenda isAttendingSession:session]){
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else {
    [cell setAccessoryType:UITableViewCellAccessoryNone];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self performSegueWithIdentifier:@"showSessionDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"showSessionDetails"]){
    SessionViewController *sessionController = (SessionViewController *)[segue destinationViewController];
    sessionController.session = [sessions objectAtIndex:[self.tableView indexPathForSelectedRow].row];
  } else if([[segue identifier] isEqualToString:@"showCategorySelection"]){
    CategorySelectionViewController *catController = (CategorySelectionViewController *)[segue destinationViewController];
    catController.categories = 
    [sessions valueForKeyPath:@"@distinctUnionOfObjects.Technology"];
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (editingStyle == UITableViewCellEditingStyleDelete){
    Session *session = [sessions objectAtIndex:indexPath.row];
    BOOL isAttending = [Agenda isAttendingSession:session];

    if(isAttending)
      [agenda removeSessionsObject:session];
    else 
      [agenda addSessionsObject:session];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  Session *session = [sessions objectAtIndex:indexPath.row];
  
  BOOL isAttending = [Agenda isAttendingSession:session];
  return (isAttending) ? @"don't attend" : @"attend";
}

@end
