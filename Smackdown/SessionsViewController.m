//
//  SessionsViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 //  Copyright (c) 2012 Leon Gersing
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "SessionsViewController.h"
#import "SessionViewController.h"
#import "SessionsTableViewCell.h"

#import "Speaker.h"

@interface SessionsViewController(Internal)
- (void)setupFetchController:(NSString *)optionalSearchTerm;
@end

@implementation SessionsViewController

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)preloadImages{
  calendarCheckImage = [UIImage imageNamed:@"calendar_checked"];
  calendarUncheckImage = [UIImage imageNamed:@"calendar_unchecked"];
}

- (void)setupFetchController:(NSString *)optionalSearchTerm{
  NSFetchRequest *req;
  NSManagedObjectContext *ctx;
  NSSortDescriptor *sortByDate;
  NSString *sectionKey;
  NSString *cacheKey;
  NSError *fetchError;
  
  req = [NSFetchRequest fetchRequestWithEntityName:@"Session"];
  
  if(optionalSearchTerm){
    NSPredicate *predicateForSearchTerm;
    predicateForSearchTerm = [NSPredicate predicateWithFormat:@"name contains[cd] %@", optionalSearchTerm];
    [req setPredicate:predicateForSearchTerm];
  }
  
  sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startAt" ascending:YES];
  [req setSortDescriptors:[NSArray arrayWithObject:sortByDate]];
  [req setFetchBatchSize:10];
  sectionKey = @"timeSlot";
  cacheKey = @"SessionsList";
  ctx = [[LGAppDelegate sharedAppDelegate] managedObjectContext];
  
  [NSFetchedResultsController deleteCacheWithName:cacheKey];
  fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:req 
                                                        managedObjectContext:ctx
                                                          sectionNameKeyPath:sectionKey
                                                                   cacheName:cacheKey];
  fetchController.delegate = self;
  if(![fetchController performFetch:&fetchError]){
    NSLog(@"fetch error: %@", fetchError); exit(-1);
  }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
  [super viewDidLoad];
  [self preloadImages];
  [self loadSessions];
  [self setupFetchController:nil];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadSessions{
  NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Session"];
  
  NSError *err = nil;
  int results = [[[LGAppDelegate sharedAppDelegate] managedObjectContext] 
                 countForFetchRequest:fetch error:&err];
  
  if(results == 0){ 
    [self loadRemote:@"Session"];
    [self loadRemote:@"Precompiler"];
  }
}

- (void)loadRemote:(NSString *)typeOfRemoteEntity{
  NSURL *sessionURL = nil;
  if([typeOfRemoteEntity isEqualToString:@"Session"]){
    sessionURL = [NSURL URLWithString:@"http://codemash.org/rest/sessions.json"]; 
  } else {
    sessionURL = [NSURL URLWithString:@"http://codemash.org/rest/precompiler.json"];
  }
  NSURLRequest *req = 
  [NSURLRequest requestWithURL:sessionURL 
                                       cachePolicy:NSURLCacheStorageAllowed 
                                   timeoutInterval:2];
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
         for(NSMutableDictionary *dic in sessionDics){
           Session *obj = [Session createObjectOfType:@"Session" attributes:dic];
           obj.name = [obj valueForKeyPath:@"properties.Title"];
           obj.startAt = [obj dateProperty];
           obj.precompiler = ([typeOfRemoteEntity isEqualToString:@"Precompiler"]);
           obj.attending = NO;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
           [spinner stopAnimating];
         });
       });
     }
   }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  SessionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
  if(!cell){
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
  }
  
  Session *session = [fetchController objectAtIndexPath:indexPath];

  cell.titleView.text = [session valueForKeyPath:@"properties.Title"];
  cell.detailView.text = 
  [NSString stringWithFormat:@"%@ - %@",
   [session valueForKeyPath:@"properties.Technology"],
   [session dateProperty]];

  cell.checkboxView.image = ([session attending]) ? calendarCheckImage : calendarUncheckImage;
  cell.difficultyView.image = [UIImage imageNamed:[[session valueForKeyPath:@"properties.Difficulty"] lowercaseString]];
  
  [cell setNeedsDisplay];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  selectedSession = [fetchController objectAtIndexPath:indexPath];
  [self performSegueWithIdentifier:@"showSessionDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"showSessionDetails"]){
    SessionViewController *sessionController = (SessionViewController *)[segue destinationViewController];
    sessionController.session = selectedSession;
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (editingStyle == UITableViewCellEditingStyleDelete){
    Session *session = [fetchController objectAtIndexPath:indexPath];
    session.attending = !session.attending;
    
    [[LGAppDelegate sharedAppDelegate] saveContext:self];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  Session *session = [fetchController objectAtIndexPath:indexPath];
  
  return ([session attending]) ? @"don't attend" : @"attend";
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
  [self setupFetchController:searchString];
  return YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
  [self setupFetchController:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 55.0f;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationTop];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationBottom];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                            withRowAnimation:UITableViewRowAnimationTop];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationBottom];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
  [self.tableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[fetchController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchController sections] objectAtIndex:section];
  return [sectionInfo name];
}


@end
