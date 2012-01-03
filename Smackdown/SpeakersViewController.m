//
//  SpeakersViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 1/3/12.
//  Copyright (c) 2012 fallenrogue.com. All rights reserved.
//

#import "SpeakersViewController.h"


@implementation SpeakersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self cacheSpeakers];
  NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Speaker"];
  [req setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
  fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                        managedObjectContext:[[LGAppDelegate sharedAppDelegate] managedObjectContext]
                                                          sectionNameKeyPath:nil
                                                                   cacheName:@"Speakers"];
  if(![fetchController performFetch:nil]){
    exit(-1);
  }
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
  return YES;
}

#pragma mark - Table view delegate

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"speakerCell"];
  Speaker *obj = [fetchController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = [obj valueForKeyPath:@"properties.Name"];
  // Configure the cell with data from the managed object.
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchController sections] objectAtIndex:section];
  return [sectionInfo name];
}


- (void)cacheSpeakers{
  NSError *fetchError;
  NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Speaker"];
  int count = [[[LGAppDelegate sharedAppDelegate] managedObjectContext] countForFetchRequest:req error:&fetchError];
  if(count == 0){
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:
                            [NSURL URLWithString:@"http://codemash.org/rest/speakers.json"]];
    
    [NSURLConnection sendAsynchronousRequest:urlReq
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:
     ^(NSURLResponse *resp, NSData *raw, NSError *reqErr){
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
         NSError *jsonErr = nil;
         NSArray *sessionDics = [NSJSONSerialization JSONObjectWithData:raw options:NSJSONReadingMutableContainers error:&jsonErr];
         for(NSMutableDictionary *dic in sessionDics){
           Speaker *obj = [Speaker createObjectOfType:@"Speaker" attributes:dic];
           obj.name = [obj valueForKeyPath:@"properties.Name"];
           obj.blog = [obj valueForKeyPath:@"properties.BlogURL"];
           obj.twitter = [obj valueForKeyPath:@"properties.TwitterHandle"];
           obj.bio = [obj valueForKeyPath:@"properties.Biography"];
           obj.speakerID = [obj valueForKeyPath:@"properties.SpeakerURI"];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
           if(!jsonErr){
             [[LGAppDelegate sharedAppDelegate] saveContext:self];
             [self.tableView reloadData];
           }
         });
       });
     }];
  }
}

@end
