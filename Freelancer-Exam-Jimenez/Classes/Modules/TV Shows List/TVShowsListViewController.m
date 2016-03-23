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
    

    //Initia state
    self.currentPage = 1;
    self.sectionedTVShows = [NSMutableArray array];
    
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
        
        if (!error && !jsonSerializationError) {
            
            [self sectionTVShowsFromResults:tvShowWrapper page:strongSelf.currentPage];
            
            strongSelf.currentPage++;
            
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
    UITableViewCell *tvShowCell = [tableView dequeueReusableCellWithIdentifier:@"TVShowCell" forIndexPath:indexPath];
    
    tvShowCell.textLabel.text = self.sectionedTVShows[indexPath.section][indexPath.row].name;
    
    return tvShowCell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

@end
