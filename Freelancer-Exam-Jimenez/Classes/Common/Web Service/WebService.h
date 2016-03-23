//
//  WebService.h
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

typedef void(^WebServiceCompletionHandler)(id, NSError*);

@interface WebService : NSObject

@property (strong, nonatomic) MTLModel<MTLJSONSerializing> *requestBodyObject;

- (void)startRequestWithCompletionHandler:(WebServiceCompletionHandler)completionHandler;

@end
