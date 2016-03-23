//
//  TVShow.h
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

#import <Mantle/Mantle.h>

@interface TVShow : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;
@property (copy, nonatomic) NSString *channel;
@property (copy, nonatomic) NSString *rating;

@end
