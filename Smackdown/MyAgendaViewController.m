//
//  MyAgendaViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "MyAgendaViewController.h"
#import "SessionsTableViewCell.h"
#import "SessionViewController.h"

@interface MyAgendaViewController(Internal)
- (void)setupFetchController;
@end

@implementation MyAgendaViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setupFetchController{
  NSFetchRequest *req;
  NSManagedObjectContext *ctx;
  NSSortDescriptor *sortByDate;
  NSPredicate *myAgendaPredicate;
  NSString *sectionKey;
  NSString *cacheKey;
  NSError *fetchError;
  
  req = [NSFetchRequest fetchRequestWithEntityName:@"Session"];
  myAgendaPredicate = [NSPredicate predicateWithFormat:@"attending == 1"];
  sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startAt" ascending:YES];
  [req setSortDescriptors:[NSArray arrayWithObject:sortByDate]];
  [req setPredicate:myAgendaPredicate];
  sectionKey = @"timeSlot";
  cacheKey = @"SessionsList";
  ctx = [[LGAppDelegate sharedAppDelegate] managedObjectContext];
  
  [NSFetchedResultsController deleteCacheWithName:cacheKey];
  fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:req 
                                                        managedObjectContext:ctx
                                                          sectionNameKeyPath:sectionKey
                                                                   cacheName:cacheKey];
  
  if(![fetchController performFetch:&fetchError]){
    NSLog(@"fetch error: %@", fetchError); exit(-1);
  }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if(!fetchController) [self setupFetchController];
  [[self tableView] reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return YES;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"agendaCell";
  
  SessionsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
      cell = [[SessionsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  Session *session = [fetchController objectAtIndexPath:indexPath];
  cell.titleView.text = [session valueForKeyPath:@"properties.Title"];
  cell.detailView.text = [session valueForKeyPath:@"properties.Room"];
  cell.difficultyView.image = [UIImage imageNamed:[[session valueForKeyPath:@"properties.Difficulty"] lowercaseString]];

  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      [tableView beginUpdates];
      Session *session = [fetchController objectAtIndexPath:indexPath];

      session.attending = !session.attending;
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView endUpdates];
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self performSegueWithIdentifier:@"showMySessionDetails" sender:self.navigationController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"showMySessionDetails"]){
    SessionViewController *sessionController = (SessionViewController *)[segue destinationViewController];
    sessionController.session = [fetchController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
  [self.tableView reloadData];
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
