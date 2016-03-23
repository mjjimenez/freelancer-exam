//
//  TVShowWrapper.m
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import "TVShowWrapper.h"
#import "TVShow.h"

@implementation TVShowWrapper

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"results": @"results",
             @"count": @"count"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TVShow class]];
}

@end
