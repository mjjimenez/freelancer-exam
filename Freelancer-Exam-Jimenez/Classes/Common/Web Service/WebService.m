//
//  WebService.m
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import "WebService.h"

#import "WebService.h"
#import <AFNetworking.h>

@implementation WebService

#pragma mark - URL Construction Methods

- (NSURL*)requestURL
{
    NSString *apiURLString = @"https://www.whatsbeef.net/wabz/guide.php";
    
    if ([self version]) {
        apiURLString = [apiURLString stringByAppendingPathComponent:[self version]];
    }
    
    NSURL *endpointURL = [NSURL URLWithString:apiURLString];
    
    return endpointURL;
}

- (NSString*)endpoint
{
    NSAssert(NO, @"Subclasses must implement this method");
    return nil;
}

- (NSString*)version
{
    NSAssert(NO, @"Subclasses must implement this method");
    return nil;
}

#pragma mark - Request Methods

- (NSDictionary*)JSONBodyFromRequesObject
{
    NSError* error;
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:self.requestBodyObject error:&error];
    
    if (error) {
        return nil;
    }
    
    return parameters;
}

- (void)startRequestWithCompletionHandler:(WebServiceCompletionHandler)completionHandler
{
    
    if (!completionHandler) {
        
        completionHandler = ^(id response, NSError *error) {
            
        };
        
    }
    
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self requestURL] sessionConfiguration:defaultSessionConfiguration];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [sessionManager POST:[self endpoint] parameters:[self JSONBodyFromRequesObject] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionHandler(responseObject, nil);
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        //TODO: Check JSON Serialization Error
        
        //TODO: Check Status code errors
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionHandler(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey], error);
            
        });
        
    }];
}

#pragma mark - Response Parser Methods

- (id)responseObjectFromServiceResponse:(id)serviceResponse
{
    NSAssert(NO, @"Subclasses must implement this method");
    return nil;
}

- (NSError*)serviceLevelErrorFromServiceResponse:(id)serviceResponse
{
    return nil;
}




@end
