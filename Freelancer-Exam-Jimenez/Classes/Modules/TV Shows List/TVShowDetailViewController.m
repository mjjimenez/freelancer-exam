//
//  TVShowDetailViewController.m
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import "TVShowDetailViewController.h"

@interface TVShowDetailViewController()

@property (strong, nonatomic) NSDictionary *tvShowResultsDictionary;
@property (weak, nonatomic) IBOutlet UIImageView *tvShowImageView;
@property (weak, nonatomic) IBOutlet UILabel *tvShowDescription;

@end

@implementation TVShowDetailViewController

- (void)viewDidLoad
{
    self.tvShowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.omdbapi.com/?t=%@&y=&plot=short&r=json", self.tvShow.name];
    NSLog(@"%@", urlString);
    NSURL *tvShowRequestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:tvShowRequestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (!resultsDictionary[@"Error"]) {
            
            strongSelf.tvShowResultsDictionary = resultsDictionary;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf displayTVShowDetails];
            });
            
            
        } else {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"TV Show Not Found" preferredStyle:UIAlertControllerStyleAlert];
            
            [strongSelf presentViewController:alertController animated:YES completion:nil];
            
        }
        
        
    }];
    
    [dataTask resume];
    
}

- (void)displayTVShowDetails
{
    NSString *imageURLString = self.tvShowResultsDictionary[@"Poster"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
    self.tvShowImageView.image = image;
    
    self.tvShowDescription.text = self.tvShowResultsDictionary[@"Plot"];

}

@end
