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
#import "Mantle.h"
#import "RNUser.h"
#import "RNCart.h"
#import "RNAccountStatement.h"
#import "RNLocalDeal.h"
#import "RNProgramInfo.h"
#import "RNCategory.h"

NSString *const kPBaseURL = @"https://api.rewardsnow.com/qa/";
NSString *const kPAPISecret = @"f7ceef815c71ce92b613a841581f641d5982cba6fa2411c3eb07bc74d5bc081";

NSString *const kResultsKey = @"Result";
NSString *const kErrorKey = @"Error";
NSString *const kStatementKey = @"Statement";
NSString *const kOffersKey = @"Offers";

@interface RNWebService()

@property (nonatomic, strong) NSString *authorizationHeader;
@property (nonatomic, copy) NSString *tip;

@end


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
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        ///
        /// Setup Default Headers
        ///
        [self setDefaultHeader:@"X-RNI-ApiKey" value:[NSString stringWithFormat:@"%@", kPAPISecret]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        self.authorizationHeader = @"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTE2Ij8+DQo8UmVzcG9uc2UgSXNzdWVJbnN0YW50PSIyMDEzLTA0LTA5VDIwOjE2OjE3LjcxMTFaIiBJRD0iXzM4ODFmNzYzLTU1YjQtNGIwZS05NjZiLWYxMWMzOWMzYjJkZiIgVmVyc2lvbj0iMi4wIiB4bWxucz0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnByb3RvY29sIj4NCiAgPFN0YXR1cz4NCiAgICA8U3RhdHVzQ29kZSBWYWx1ZT0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnN0YXR1czpTdWNjZXNzIiAvPg0KICA8L1N0YXR1cz4NCiAgPEFzc2VydGlvbiBJRD0iX2M4ODU2ZDhjLWQxZGYtNDMzMC04ODMyLWFiMTExMTMyNWEwMSIgSXNzdWVJbnN0YW50PSIyMDEzLTA0LTA5VDIwOjE2OjE3LjcxMVoiIFZlcnNpb249IjIuMCIgeG1sbnM9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphc3NlcnRpb24iPg0KICAgIDxJc3N1ZXI+Z2F1LnJld2FyZHNub3cuY29tPC9Jc3N1ZXI+DQogICAgPGRzOlNpZ25hdHVyZSB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+DQogICAgICA8ZHM6U2lnbmVkSW5mbz4NCiAgICAgICAgPGRzOkNhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiIC8+DQogICAgICAgIDxkczpTaWduYXR1cmVNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNyc2Etc2hhMjU2IiAvPg0KICAgICAgICA8ZHM6UmVmZXJlbmNlIFVSST0iI19jODg1NmQ4Yy1kMWRmLTQzMzAtODgzMi1hYjExMTEzMjVhMDEiPg0KICAgICAgICAgIDxkczpUcmFuc2Zvcm1zPg0KICAgICAgICAgICAgPGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNlbnZlbG9wZWQtc2lnbmF0dXJlIiAvPg0KICAgICAgICAgICAgPGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIgLz4NCiAgICAgICAgICA8L2RzOlRyYW5zZm9ybXM+DQogICAgICAgICAgPGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIgLz4NCiAgICAgICAgICA8ZHM6RGlnZXN0VmFsdWU+dmExenJrL3NJSzVoVTdDd2JESHN6M3hwb1dscVZTUTdZamdTYk1taGs0bz08L2RzOkRpZ2VzdFZhbHVlPg0KICAgICAgICA8L2RzOlJlZmVyZW5jZT4NCiAgICAgIDwvZHM6U2lnbmVkSW5mbz4NCiAgICAgIDxkczpTaWduYXR1cmVWYWx1ZT5RMDB0ZnIvY3pvUTlEZHROc1BBS0cranJMRzI5V0RQUVVLUjhlbzIrSkpzdElsOFpjV3RiRG9XUEU0eFJNQW1JRWFGSzhUMDQ0SGxGT1lnVlY3djAwQSt0cXd2eDA2Y0lUTnBGc1BUN01YZTNIV2lPNmFaTnI3T1labzRRTXNva1NIVmgvRkRjTm1SSzR4R3NVcWM1Z1hyVTBYeXl4Ti9SNU05TlBRR1hMNUU9PC9kczpTaWduYXR1cmVWYWx1ZT4NCiAgICAgIDxLZXlJbmZvIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4NCiAgICAgICAgPFg1MDlEYXRhPg0KICAgICAgICAgIDxYNTA5Q2VydGlmaWNhdGU+TUlJREdqQ0NBb2VnQXdJQkFnSVFCaFNtamVHMGZwdENZU1AxU25SRkhqQUpCZ1VyRGdNQ0hRVUFNSUc2TVJzd0dRWURWUVFERXhKbllYVXVjbVYzWVhKa2MyNXZkeTVqYjIweFJEQkNCZ05WQkFzVE96Sm1JR013SUdNMElEUm1JRFkySURVMUlHTmtJR1UzSURJeklEazNJR0ZrSUdRMklEUXlJREJrSURNMklEVTVJR015SUdVNElHTTJJRGN4TVZVd1V3WURWUVFLSGt3QWV3QTNBRVVBUmdBeUFFSUFNUUExQUVVQUxRQTJBRUVBTmdBeUFDMEFOQUExQURnQU9BQXRBRUlBTmdBeEFFVUFMUUF6QUVNQVFnQkdBRFFBTVFBMkFFWUFRUUF4QURVQU5RQjlNQjRYRFRFeU1USXlOekUwTkRnMU9Gb1hEVEV6TVRJeU56RTBORGcxT0Zvd2dib3hHekFaQmdOVkJBTVRFbWRoZFM1eVpYZGhjbVJ6Ym05M0xtTnZiVEZFTUVJR0ExVUVDeE03TW1ZZ1l6QWdZelFnTkdZZ05qWWdOVFVnWTJRZ1pUY2dNak1nT1RjZ1lXUWdaRFlnTkRJZ01HUWdNellnTlRrZ1l6SWdaVGdnWXpZZ056RXhWVEJUQmdOVkJBb2VUQUI3QURjQVJRQkdBRElBUWdBeEFEVUFSUUF0QURZQVFRQTJBRElBTFFBMEFEVUFPQUE0QUMwQVFnQTJBREVBUlFBdEFETUFRd0JDQUVZQU5BQXhBRFlBUmdCQkFERUFOUUExQUgwd2daOHdEUVlKS29aSWh2Y05BUUVCQlFBRGdZMEFNSUdKQW9HQkFMZHh5RjRUc1lpVWt2b1JNM1drZkZDTlZxTUFnQzVnbkJ4TTdiT1ZraGgvYVFGK0JCL2dPRElacDRnYllyYXZNYjV4VlY2VFBzRXVGa0R5Z1Z6bTNTTm5ZeitvQTd2N2owaGtmLzVPT3EvaFRPNHRkMFlzYUVnWlQ4QTZqQjZGeEtzUjVjNzJqM1NiOVdoQkc4aENSUkZWemFVYkhkVFpMZFI1SnB1V2hYZzVBZ01CQUFHakp6QWxNQk1HQTFVZEpRUU1NQW9HQ0NzR0FRVUZCd01CTUE0R0ExVWREd1FIQXdVQXNBQUFBREFKQmdVckRnTUNIUVVBQTRHQkFCWENiaVRybUJRd084NVErSDU5QjZ3ZU9YZ251d1QvM1Z0aTg5Zi9XcFphbHJCRXZ1T3FqNUNqdk1nL3g3NGhYMkk3OGhQMnBTenZ4Z2JYVXZiQ1hibDUxUm5sZTdHbDNXVGlmZGZYVk9TcTFVNFUrVHpEV2o0RDBCajhWSDZhRmxabDVQUkVtckc5Uks0bEYyU3poV1ZMaHRlOWwxMnpKTmIrc2pXb1F5SmE8L1g1MDlDZXJ0aWZpY2F0ZT4NCiAgICAgICAgPC9YNTA5RGF0YT4NCiAgICAgIDwvS2V5SW5mbz4NCiAgICA8L2RzOlNpZ25hdHVyZT4NCiAgICA8U3ViamVjdD4NCiAgICAgIDxTdWJqZWN0Q29uZmlybWF0aW9uIE1ldGhvZD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOmNtOmJlYXJlciI+DQogICAgICAgIDxTdWJqZWN0Q29uZmlybWF0aW9uRGF0YSBOb3RPbk9yQWZ0ZXI9IjIwMTMtMDQtMDlUMjA6MTc6MTcuNzA5WiIgUmVjaXBpZW50PSJodHRwOi8vbG9jYWxob3N0OjgwMDMvIiAvPg0KICAgICAgPC9TdWJqZWN0Q29uZmlybWF0aW9uPg0KICAgIDwvU3ViamVjdD4NCiAgICA8Q29uZGl0aW9ucyBOb3RCZWZvcmU9IjIwMTMtMDQtMDlUMjA6MTY6MTcuNzA5WiIgTm90T25PckFmdGVyPSIyMDEzLTA0LTA5VDIwOjE3OjE3LjcwOVoiPg0KICAgICAgPEF1ZGllbmNlUmVzdHJpY3Rpb24+DQogICAgICAgIDxBdWRpZW5jZT5odHRwOi8vbG9jYWxob3N0OjgwMDMvPC9BdWRpZW5jZT4NCiAgICAgIDwvQXVkaWVuY2VSZXN0cmljdGlvbj4NCiAgICA8L0NvbmRpdGlvbnM+DQogICAgPEF0dHJpYnV0ZVN0YXRlbWVudD4NCiAgICAgIDxBdHRyaWJ1dGUgTmFtZT0iaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI+DQogICAgICAgIDxBdHRyaWJ1dGVWYWx1ZT5GSVVzZXI8L0F0dHJpYnV0ZVZhbHVlPg0KICAgICAgPC9BdHRyaWJ1dGU+DQogICAgICA8QXR0cmlidXRlIE5hbWU9Imh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI+DQogICAgICAgIDxBdHRyaWJ1dGVWYWx1ZT53ZWJAcmV3YXJkc25vdy5jb208L0F0dHJpYnV0ZVZhbHVlPg0KICAgICAgPC9BdHRyaWJ1dGU+DQogICAgICA8QXR0cmlidXRlIE5hbWU9Imh0dHA6Ly9SZXN0ZnVsVG9rZW5TZXJ2aWNlL3RpcG51bWJlciI+DQogICAgICAgIDxBdHRyaWJ1dGVWYWx1ZT5SRUI5OTk5OTk5OTk5MDAgICAgIDwvQXR0cmlidXRlVmFsdWU+DQogICAgICA8L0F0dHJpYnV0ZT4NCiAgICA8L0F0dHJpYnV0ZVN0YXRlbWVudD4NCiAgICA8QXV0aG5TdGF0ZW1lbnQgQXV0aG5JbnN0YW50PSIyMDEzLTA0LTA5VDIwOjE2OjE3LjcxMVoiPg0KICAgICAgPEF1dGhuQ29udGV4dD4NCiAgICAgICAgPEF1dGhuQ29udGV4dENsYXNzUmVmPnVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphYzpjbGFzc2VzOlBhc3N3b3JkPC9BdXRobkNvbnRleHRDbGFzc1JlZj4NCiAgICAgIDwvQXV0aG5Db250ZXh0Pg0KICAgIDwvQXV0aG5TdGF0ZW1lbnQ+DQogIDwvQXNzZXJ0aW9uPg0KPC9SZXNwb25zZT4=";
        
        [self setDefaultHeader:@"Authorization" value:self.authorizationHeader];
        
        self.parameterEncoding = AFJSONParameterEncoding;
        
    }
    return self;
}

- (void)getRewards:(NSString *)tipFirst WithCallback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetRedemptions/%@", tipFirst];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
//                                                                                     DLog(@"Requst: %@", response);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSArray *objects = [RNRedeemObject objectsFromJSON:[JSON objectForKey:kResultsKey]];
                                                                                         // cache?
                                                                                         callback(objects);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                     
                                                                                     
                                                                                     
                                                                                     
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %@", request);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)getDeals:(NSString *)tipFirst location:(CLLocation *)location query:(NSString *)query callback:(RNResultCallback)callback {
    [self getDeals:tipFirst location:location query:query limit:20 offset:0 radius:15.0 category:nil callback:callback];
}

- (void)getSecretQuestion:(NSString *)tip callback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSString *url = [NSString stringWithFormat:@"StsService.svc/GetSecretQuestion/%@", tip];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                                                                                                          
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         callback(JSON[@"Question"]);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %@", request);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];

}


- (void)getDeals:(NSString *)tipFirst location:(CLLocation *)location query:(NSString *)query limit:(NSInteger)lim offset:(NSInteger)offset radius:(double)radius category:(NSNumber *)category callback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetLocalOffers/%@/", tipFirst];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"limit" : @(lim),
                                   @"offset" : @(offset),
                                   @"lat" : @(location.coordinate.latitude),
                                   @"lon" : @(location.coordinate.longitude),
                                   @"radius" : @(radius)}];
    
    if ([query isNotEmpty]) [params setValue:query forKey:@"q"];
    if (category != nil) [params setValue:category forKey:@"categoryid"];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];

    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:params]
                                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                 [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                 
                                                                                 DLog(@"Response: %@", JSON);
                                                                                 
                                                                                 if ([self wasSuccessful:JSON]) {
                                                                                     NSArray *objects = [RNLocalDeal objectsFromJSON:[JSON objectForKey:kOffersKey]];
                                                                                     // cache?
                                                                                     callback(objects);
                                                                                 } else {
                                                                                     callback(nil);
                                                                                 }
                                                                                 
                                                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                 [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                 DLog(@"FAILURE: %@", error);
                                                                                 DLog(@"JSON: %@", JSON);
                                                                                 DLog(@"Test: %@", request);
                                                                                 callback(nil);
                                                                             }];
    [self enqueueHTTPRequestOperation:op];

}


- (void)getBranding:(NSString *)code callback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *url = [NSString stringWithFormat:@"StsService.svc/GetBranding/%@", code];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"Response: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
//                                                                                         NSArray *objects = [RNLocalDeal objectsFromJSON:[JSON objectForKey:kOffersKey]];
                                                                                         // cache?
                                                                                         callback(JSON);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %@", request);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];

}

- (void)getCartWithCallback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetCart/%@/0", _tip];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     //                                                                                     DLog(@"Requst: %@", response);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         callback([RNRedeemObject objectsFromJSON:JSON[@"ShoppingCart"]]);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %@", request);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}



- (void)getAccountStatementForTip:(NSString *)tip From:(NSDate *)from to:(NSDate *)to callback:(RNResultCallback)callback {
    static NSDateFormatter *formatter = nil;
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
    }
    
    [formatter setDateFormat:@"yyyy-M-d"];
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetMobileStatement/%@/%@/%@", tip, [formatter stringFromDate:from], [formatter stringFromDate:to]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"Requst: %@", response);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if (YES/*[self wasSuccessful:JSON]*/) {
                                                                                         
                                                                                         DLog(@"WHAT: %@", [JSON objectForKey:kStatementKey]);
                                                                                         DLog(@"WHAT2: %@", NSStringFromClass([[JSON objectForKey:kStatementKey] class]));
                                                                                         NSArray *objects = [RNAccountStatement objectsFromJSON:@[[JSON objectForKey:kStatementKey]]];
                                                                                         // cache?
                                                                                         callback([objects lastObject]);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password code:(NSNumber *)code callback:(RNResultCallback)callback {
    ///
    /// Perform the authentication
    ///
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        callback(@{@"success" : @"true"});
    });

}

- (void)getAccountInfoWithTip:(NSNumber *)tip callback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetMyAccountInfo/%@", tip];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSError *error = nil;
                                                                                         RNUser *user = [MTLJSONAdapter modelOfClass:[RNUser class] fromJSONDictionary:JSON error:&error];
                                                                                         if (error != nil) {
                                                                                             DLog(@"Error creating RNUser: %@", error);
                                                                                         }
                                                                                         
                                                                                         callback(user);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                     
                                                                                     
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)getProgramInfo:(NSString *)tip callback:(RNResultCallback)callback {
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetProgramInfo/%@", tip];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSArray *objects = [RNProgramInfo objectsFromJSON:@[JSON]];
                                                                                         DLog(@"Objects: %@", objects);
                                                                                         callback([objects lastObject]);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                     
                                                                                     
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}


- (void)getLocalCategories:(NSString *)tip callback:(RNResultCallback)callback {
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetLocalCategories/%@", tip];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSArray *objects = [RNCategory objectsFromJSON:JSON[@"Categories"]];
                                                                                         DLog(@"Objects: %@", objects);
                                                                                         callback(objects);
                                                                                     } else {
                                                                                         callback(nil);
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(nil);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}


- (void)putEmail:(NSString *)email callback:(RNResultCallback)callback {
    
//    NSString *url = [NSString stringWithFormat:@"email"];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        callback(@{@"success" : @"true"});
    });
}

#pragma mark - POST

- (void)postResetPassword:(NSString *)tip answer:(NSString *)answer password:(NSString *)password passwordConfirm:(NSString *)confirmed username:(NSString *)username fullName:(NSString *)fullName callback:(RNResultCallback)callback {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipNumber": tip,
                             @"answer": answer,
                             @"newpassword": password,
                             @"newpasswordconfirm": confirmed,
                             @"username": username,
                             @"fullname": fullName};
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:@"StsService.svc/ResetPassword" parameters:params]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if (JSON[@"IsValid"]) {
                                                                                         callback(@YES);
                                                                                     } else {
                                                                                         callback(@NO);
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(@NO);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)postChangePassword:(NSString *)tip username:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword callback:(RNResultCallback)callback {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipNumber": tip,
                             @"oldpassword": oldPassword,
                             @"newpassword": newPassword,
                             @"newpasswordconfirm": confirmPassword,
                             @"username": username};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"StsService.svc/ChangePassword" parameters:nil];
    [request setHTTPBody:data];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if (JSON[@"IsValid"]) {
                                                                                         callback(@YES);
                                                                                     } else {
                                                                                         callback(@NO);
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(@NO);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)postCatalogIDToCart:(NSNumber *)catalogID callback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipnumber": _tip,
                             @"catalogid": catalogID,
                             @"wishlist": @0,
                             @"active": @1};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"FacadeService.svc/AddToCart" parameters:nil];
    [request setHTTPBody:data];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         callback(@YES);
                                                                                     } else {
                                                                                         callback(@NO);
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     callback(@NO);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
    
}

- (BOOL)wasSuccessful:(id)JSON {
    return [JSON isKindOfClass:[NSDictionary class]] && (JSON[kErrorKey] == nil || JSON[kErrorKey] == [NSNull null]);
}


@end
