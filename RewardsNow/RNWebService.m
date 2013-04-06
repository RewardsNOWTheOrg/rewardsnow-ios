//
//  RNWebService.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNWebService.h"
#import "AFJSONRequestOperation.h"
#import "RNRedeemObject.h"


NSString *const kPBaseURL = @"https://api.rewardsnow.com/qa/FacadeService.svc/";
NSString *const kPAPISecret = @"f7ceef815c71ce92b613a841581f641d5982cba6fa2411c3eb07bc74d5bc081";
NSString *const kResultsKey = @"Result";

@implementation RNWebService

+ (instancetype)sharedClient {
    static RNWebService *_sharedWebService;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWebService = [[RNWebService alloc] initWithBaseURL:[NSURL URLWithString:kPBaseURL]];
    });
    
    return _sharedWebService;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    if ( (self = [super initWithBaseURL:url]) ) {
        
        ///
        /// Setup Default Headers
        ///
        [self setDefaultHeader:@"X-RNI-ApiKey" value:[NSString stringWithFormat:@"%@", kPAPISecret]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        self.parameterEncoding = AFJSONParameterEncoding;
        
    }
    return self;
}

- (void)getRewards:(NSString *)tipFirst WithCallback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"GetRedemptions/%@", tipFirst];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     
                                                                                     NSMutableArray *toReturn = [NSMutableArray array];
                                                                                     for (NSDictionary *d in [JSON objectForKey:kResultsKey]) {
                                                                                         [toReturn addObject:[[RNRedeemObject alloc] initWithDictionary:d]];
                                                                                     }
                                                                                     
                                                                                     callback(toReturn);
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}


@end
