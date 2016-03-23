//
//  TVShowsListViewController.m
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import "TVShowsListViewController.h"
#import "TVShowDetailViewController.h"
#import "TVShow.h"
#import "TVShowWrapper.h"
#import "TVShowTableViewCell.h"

@interface TVShowsListViewController()

@property (strong, nonatomic) NSMutableArray<NSArray<TVShow* > *> *sectionedTVShows;
@property (copy, nonatomic) NSURLSession *tvShowsAPISession;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UIView *loadingFooterView;
@property BOOL isLoadingNextPage;

@property (copy, nonatomic) TVShow *selectedTVShow;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *currentDate;

@end

@implementation TVShowsListViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *navbarColor = [UIColor colorWithRed:24.0 green:147.0 blue:200 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:navbarColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //Initial state
    self.currentPage = 1;
    self.sectionedTVShows = [NSMutableArray array];
    self.currentDate = [NSDate date];
    
    //Table View state
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 96;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.tvShowsAPISession = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    [self loadNextPageOfTVShows];
    
}

#pragma mark - Lazy loaded properties

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"YYYY-dd-MM"];
    }
    
    return _dateFormatter;
}

- (UIView *)loadingFooterView
{
    if (!_loadingFooterView) {
        _loadingFooterView = [[UIView alloc] init];
        _loadingFooterView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 40);
        _loadingFooterView.backgroundColor = [UIColor lightGrayColor];
        
        UIActivityIndicatorView *loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingIndicatorView startAnimating];
        [_loadingFooterView addSubview:loadingIndicatorView];
        loadingIndicatorView.center = CGPointMake(CGRectGetMidX(_loadingFooterView.frame), CGRectGetMidY(_loadingFooterView.frame));
    }
    
    return _loadingFooterView;
}

#pragma mark - TVShow Business Logic

- (NSURL *)currentPageURL
{
    NSString *tvShowsURLString = [NSString stringWithFormat:@"https://www.whatsbeef.net/wabz/guide.php?start=%ld", (long)self.currentPage];
    NSURL *tvShowsURL = [NSURL URLWithString:tvShowsURLString];
    
    return tvShowsURL;
}

- (void)loadNextPageOfTVShows
{
    self.isLoadingNextPage = YES;
    
    NSURL *tvShowsURL = [self currentPageURL];
    
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
        
        strongSelf.isLoadingNextPage = NO;
        
    }];
    
    [initialPageTVShowsTask resume];
}

- (void)sectionTVShowsFromResults:(TVShowWrapper *)tvShowWrapper page:(NSInteger)page
{
    page = MAX(0, page);
    NSInteger sectionIndex = page -1;
    self.sectionedTVShows[sectionIndex] = tvShowWrapper.results;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tableView reloadData];
        self.tableView.tableFooterView = nil;
        
    });
}

#pragma mark - View Logic

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
    if (section == 0) {
        return @"TONIGHT";
    } else {
        
        NSInteger daysToRemoveFromCurrentDate = section + 1;
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.day = -daysToRemoveFromCurrentDate;
        NSDate *sectionDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.currentDate options:0];
        
        NSString *headerString = [self.dateFormatter stringFromDate:sectionDate];
        
        return headerString;
        
    }
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTVShow = self.sectionedTVShows[indexPath.section][indexPath.row];
    [self performSegueWithIdentifier:@"ShowTVShowDetail" sender:self];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if (distanceFromBottom <= (scrollViewHeight + 100) && !self.isLoadingNextPage) {
        
        [self loadNextPageOfTVShows];
        self.tableView.tableFooterView = self.loadingFooterView;
        
    }
}

#pragma mark - Storyboard Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTVShowDetail"]) {
        
        TVShowDetailViewController *detailViewController = (TVShowDetailViewController *)segue.destinationViewController;
        detailViewController.tvShow = self.selectedTVShow;
    }
}

@end
