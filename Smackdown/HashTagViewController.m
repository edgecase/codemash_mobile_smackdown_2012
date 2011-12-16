//
//  HashTagViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/15/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "HashTagViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation HashTagViewController

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
  canRefresh = YES;
}


- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if(canRefresh){
    canRefresh = NO;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"#codemash", @"q", nil];
    
    TWRequest *req = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://search.twitter.com/search.json"] parameters:params requestMethod:TWRequestMethodGET];
    [req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
      tweets = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL] objectForKey:@"results"];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
          canRefresh = YES;
        });
      });
    }];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"tweetCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  NSMutableDictionary *tweet = [tweets objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [tweet objectForKey:@"text"];
  cell.textLabel.text = [tweet objectForKey:@"from_user"];

  cell.imageView.layer.cornerRadius = 6.0f;
  cell.imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
  cell.imageView.layer.masksToBounds = YES;
  cell.imageView.layer.borderWidth = 1.0f;
  
  UIImage *img = nil;
  
  NSString *imageCacheKey= [tweet objectForKey:@"profile_image_url"];
  if(avatars && [avatars objectForKey:imageCacheKey]){
    img = [avatars objectForKey:imageCacheKey];
    cell.imageView.image = img;
  } else {
    if(!avatars)
      avatars = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if([[avatars allKeys] containsObject:imageCacheKey]) return cell;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:imageCacheKey]];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
      dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *img = [UIImage imageWithData:data];
        [avatars setObject:img forKey:imageCacheKey];
        cell.imageView.image = img;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      });
    }];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if([TWTweetComposeViewController canSendTweet]){
    NSMutableDictionary *tweet = [tweets objectAtIndex:indexPath.row];
    TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];      
    [tweetController setInitialText:[NSString stringWithFormat:@"@%@ ",[tweet objectForKey:@"from_user"]]];
    [self presentModalViewController:tweetController animated:YES];
  }
}

@end
