//
//  TVShow.m
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

//{
//    "name": "Hannibal",
//    "start_time": "10:40pm",
//    "end_time": "11:35pm",
//    "channel": "Seven",
//    "rating": "AV"
//},

#import "TVShow.h"

@implementation TVShow

 + (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name": @"name",
             @"startTime": @"start_time",
             @"endTime": @"end_time",
             @"channel": @"channel",
             @"rating": @"rating"
             };
}

@end
