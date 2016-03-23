//
//  TVShowWrapper.h
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "TVShow.h"

@interface TVShowWrapper : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSArray<TVShow *> *results;
@property (assign, nonatomic) NSInteger count;

@end
