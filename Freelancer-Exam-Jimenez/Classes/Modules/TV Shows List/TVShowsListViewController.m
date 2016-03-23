//
//  TVShowsListViewController.m
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import "TVShowsListViewController.h"
#import "TVShow.h"
#import "TVShowWrapper.h"
#import "TVShowTableViewCell.h"

@interface TVShowsListViewController()

@property (strong, nonatomic) NSMutableArray<NSArray<TVShow* > *> *sectionedTVShows;
@property (copy, nonatomic) NSURLSession *tvShowsAPISession;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation TVShowsListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *navbarColor = [UIColor colorWithRed:24.0 green:147.0 blue:200 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:navbarColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //Initial state
    self.currentPage = 1;
    self.sectionedTVShows = [NSMutableArray array];
    
    //Table View state
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 96;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.tvShowsAPISession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSString *tvShowsURLString = [NSString stringWithFormat:@"https://www.whatsbeef.net/wabz/guide.php?start=%ld", (long)self.currentPage];
    NSURL *tvShowsURL = [NSURL URLWithString:tvShowsURLString];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *initialPageTVShowsTask = [self.tvShowsAPISession dataTaskWithURL:tvShowsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSError *jsonSerializationError;
        TVShowWrapper *tvShowWrapper = [MTLJSONAdapter modelOfClass:[TVShowWrapper class] fromJSONDictionary:resultsDictionary error:&jsonSerializationError];
        
        if (!error && !jsonSerializationError && resultsDictionary != nil) {
            
            [self sectionTVShowsFromResults:tvShowWrapper page:strongSelf.currentPage];
            
            strongSelf.currentPage++;
            
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Network error. Please Try again." preferredStyle:UIAlertControllerStyleAlert];
            
            [strongSelf presentViewController:alertController animated:YES completion:nil];
            
            
        }
        
    }];
    
    [initialPageTVShowsTask resume];
}

#pragma mark - TVShow Business Logic

- (void)sectionTVShowsFromResults:(TVShowWrapper *)tvShowWrapper page:(NSInteger)page
{
    page = MAX(0, page);
    NSInteger sectionIndex = page -1;
    self.sectionedTVShows[sectionIndex] = tvShowWrapper.results;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tableView reloadData];
        
    });
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionedTVShows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionedTVShows[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVShowTableViewCell *tvShowCell = [tableView dequeueReusableCellWithIdentifier:@"TVShowCell" forIndexPath:indexPath];
    
    TVShow *tvShow = self.sectionedTVShows[indexPath.section][indexPath.row];
    
    tvShowCell.channelImageView.image = [UIImage imageNamed:tvShow.channel];
    tvShowCell.ratingImageView.image = [UIImage imageNamed:tvShow.rating];
    tvShowCell.tvShowNameLabel.text = tvShow.name;
    tvShowCell.timeSlotLabel.text = [NSString stringWithFormat:@"%@ - %@", tvShow.startTime, tvShow.endTime];
    
    return tvShowCell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if (distanceFromBottom <= (scrollViewHeight + 100)) {
        
        NSLog(@"Load next page");
        //TODO: Load next page.
        
    }
}

@end
