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
#import "RNBranding.h"
#import "RNCategory.h"
#import "RNResponse.h"
#import "RNConstants.h"

NSString *const kPBaseURL = @"https://api.rewardsnow.com/qa/";
NSString *const kPAPISecret = @"f7ceef815c71ce92b613a841581f641d5982cba6fa2411c3eb07bc74d5bc081";

NSString *const kResultsKey = @"Result";
NSString *const kErrorKey = @"Error";
NSString *const kStatementKey = @"Statement";
NSString *const kOffersKey = @"Offers";

typedef void (^RNAuthCallback)();

#define SAFE_BLOCK(block, ...) block ? block(__VA_ARGS__) : nil
#define RNError [NSError errorWithDomain:@"RNError" code:1 userInfo:nil]
#define RNErrorString @"There was an error in fetching the information. Please try again."
#define UNKNOWN_ERROR_RESPONSE_AND_CALLBACK SAFE_BLOCK(callback, [RNResponse responseWithError:RNError errorString:RNErrorString statusCode:0])
#define CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response, authCallback, SAFE_BLOCK) if (response.statusCode == 401) {[self showLoginScreen:authCallback];} else {SAFE_BLOCK;}

@interface RNWebService()

@property (nonatomic, strong) NSString *authorizationHeader;
@property (nonatomic, strong) RNAuthCallback authCallback;

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
//        self.authorizationHeader;
        
        self.parameterEncoding = AFJSONParameterEncoding;
        
    }
    return self;
}

- (void)getRewardsWithCallback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetRedemptions/%@", _tipNumber];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %d", response.statusCode);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSArray *objects = [RNRedeemObject objectsFromJSON:[JSON objectForKey:kResultsKey]];
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:objects statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %@", request);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self getRewardsWithCallback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));

                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)getDealsAtLocation:(CLLocation *)location query:(NSString *)query callback:(RNResultCallback)callback {
    [self getDealsAtLocation:location query:query limit:20 offset:0 radius:15.0 category:nil callback:callback];
}

- (void)getDealsAtLocation:(CLLocation *)location query:(NSString *)query limit:(NSInteger)lim offset:(NSInteger)offset radius:(double)radius category:(NSNumber *)category callback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetLocalOffers/%@/", _tipNumber];
    
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
                                                                                     SAFE_BLOCK(callback, [RNResponse responseWithResult:objects statusCode:response.statusCode]);
                                                                                 } else {
                                                                                     UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                 }
                                                                                 
                                                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                 [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                 
                                                                                 
                                                                                 
                                                                                 CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                              ^{ [self getDealsAtLocation:location query:query limit:lim offset:offset radius:radius category:category callback:callback]; },
                                                                                                                              SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                 
                                                                             }];
    [self enqueueHTTPRequestOperation:op];

}


- (void)getBranding:(NSString *)code callback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *url = [NSString stringWithFormat:@"StsService.svc/GetBranding/%@", code];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:url parameters:nil];
    [request setAllHTTPHeaderFields:@{@"X-RNI-ApiKey": kPAPISecret, @"Accept": @"application/json"}];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"Response: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         RNBranding *branding = [RNBranding sharedBrandingFromDictionary:[JSON objectForKey:@"Brandings"]];
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:branding statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %@", request);
                                                                                     
                                                                                     SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];

}

- (void)getCartWithCallback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetCart/%@/0", _tipNumber];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:[RNRedeemObject objectsFromJSON:JSON[@"ShoppingCart"]] statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     DLog(@"Test: %@", request);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self getCartWithCallback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                     
                                                                                     
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}



- (void)getAccountStatementFrom:(NSDate *)from to:(NSDate *)to callback:(RNResultCallback)callback {
    static NSDateFormatter *formatter = nil;
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
    }
    
    [formatter setDateFormat:@"yyyy-M-d"];
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetMobileStatement/%@/%@/%@", _tipNumber, [formatter stringFromDate:from], [formatter stringFromDate:to]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSArray *objects = [RNAccountStatement objectsFromJSON:@[[JSON objectForKey:kStatementKey]]];
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:[objects lastObject] statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self getAccountStatementFrom:from to:to callback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                     
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)getAccountInfoWithTipWithCallback:(RNResultCallback)callback {
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetMyAccountInfo/%@", _tipNumber];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:url parameters:nil];
    DLog(@"Headers: %@", request.allHTTPHeaderFields);
    
    DLog(@"Request: %@", request);
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSError *error = nil;
                                                                                         RNUser *user = [MTLJSONAdapter modelOfClass:[RNUser class] fromJSONDictionary:JSON error:&error];
                                                                                         if (error != nil) {
                                                                                             DLog(@"Error creating RNUser: %@", error);
                                                                                             SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[error description] statusCode:0]);
                                                                                         }
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:user statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                     
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self getAccountInfoWithTipWithCallback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)getProgramInfoWithCallback:(RNResultCallback)callback {
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetProgramInfo/%@", _tipNumber];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSArray *objects = [RNProgramInfo objectsFromJSON:@[JSON]];
                                                                                         DLog(@"Objects: %@", objects);
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:[objects lastObject] statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                     
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self getProgramInfoWithCallback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                     
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}


- (void)getLocalCategoriesWithCallback:(RNResultCallback)callback {
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetLocalCategories/%@", _tipNumber];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:url parameters:nil]
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         NSArray *objects = [RNCategory objectsFromJSON:JSON[@"Categories"]];
                                                                                         DLog(@"Objects: %@", objects);
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:objects statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self getLocalCategoriesWithCallback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}


#pragma mark - PUT


- (void)putEmail:(NSString *)email callback:(RNResultCallback)callback {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"FacadeService.svc/UpdateMyAccount" parameters:nil];
    
    NSDictionary *dataDictionary = @{@"tipnumber": _tipNumber, @"email" : email};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:NULL];
    [request setHTTPBody:data];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON[@"UpdateMyAccountResult"]]) {
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:JSON[@"UpdateMyAccountResult"][@"Email"] statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self putEmail:email callback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                     
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

#pragma mark - POST

- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(RNResultCallback)callback {
    ///
    /// Perform the authentication
    ///
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"StsService.svc/Login" parameters:nil];
    NSDictionary *params = @{@"tipfirst": _tipNumber};
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    [request setHTTPBody:data];
    
    NSString *base64Auth = [RNWebService encodeBase64WithString:[NSString stringWithFormat:@"%@:%@", username, password]];
    // Set our own HTTP headers
    [request setAllHTTPHeaderFields:@{@"X-RNI-ApiKey": kPAPISecret, @"Accept": @"application/json", @"Authorization" : base64Auth}];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         self.authorizationHeader = JSON[@"Token"];
                                                                                         [self setDefaultHeader:@"Authorization" value:self.authorizationHeader];
                                                                                         self.tipNumber = [JSON[@"Tipnumber"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:@YES statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)postChangePasswordWithUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword callback:(RNResultCallback)callback {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipNumber": _tipNumber,
                             @"oldpassword": oldPassword,
                             @"newpassword": newPassword,
                             @"newpasswordconfirm": confirmPassword,
                             @"username": username};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"FacadeService.svc/ChangePassword" parameters:nil];
    [request setHTTPBody:data];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([JSON[@"IsValid"] boolValue]) {
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:@YES statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]);
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)postCatalogIDToCart:(NSString *)catalogID callback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipnumber": _tipNumber,
                             @"catalogid": catalogID,
                             @"wishlist": @0,
                             @"active": @1};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"FacadeService.svc/AddToCart" parameters:nil];
    [request setHTTPBody:data];
    
    DLog(@"Request: %@", request);
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:@YES statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self postCatalogIDToCart:catalogID callback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)postRemoveItemFromCart:(NSString *)catalogID callback:(RNResultCallback)callback;
{
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipnumber": _tipNumber,
                             @"catalogid": catalogID,
                             @"wishlist": @0
                             };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"FacadeService.svc/RemoveFromCart" parameters:nil];
    [request setHTTPBody:data];
    
    DLog(@"Request: %@", request);
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON[@"RemoveFromShoppingCartResult"]]) {
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:@YES statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self postRemoveItemFromCart:catalogID callback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
    
}

- (void)postPlaceOrderForUser:(RNUser *)user items:(NSArray *)redemptions  callback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableDictionary *postParameters = [NSMutableDictionary dictionary];
    [postParameters setValue:_tipNumber forKey:@"tipnumber"];
    [postParameters setValue:user.email forKey:@"CustomerEmail"];
    [postParameters setValue:user.address forKey:@"saddress1"];
    [postParameters setValue:user.apt forKey:@"saddress2"];
    [postParameters setValue:user.city forKey:@"scity"];
    [postParameters setValue:user.state forKey:@"sstate"];
    [postParameters setValue:user.zipCode forKey:@"szipcode"];
    [postParameters setValue:redemptions forKey:@"Redemptions"];
    [postParameters setValue:@"" forKey:@"scountry"];
    [postParameters setValue:@"" forKey:@"hphone"];
    [postParameters setValue:@"" forKey:@"wphone"];
    
    //set redemptions
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:postParameters options:0 error:NULL];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"FacadeService.svc/PlaceOrderEx" parameters:nil];
    [request setHTTPBody:data];
    
    DLog(@"Request: %@",  request);
    DLog(@"Request1: %@",  request.allHTTPHeaderFields);
    DLog(@"Request2: %@",  postParameters);
    
    DLog(@"What we sent: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         SAFE_BLOCK(callback, [RNResponse responseWithResult:@YES statusCode:response.statusCode]);
                                                                                     } else {
                                                                                         UNKNOWN_ERROR_RESPONSE_AND_CALLBACK;
                                                                                     }
                                                                                     
                                                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     DLog(@"FAILURE: %@", error);
                                                                                     
                                                                                     CHECK_UNAUTHORIZED_AND_CALLBACK_IF_AUTHORIZED(response,
                                                                                                                                   ^{ [self postPlaceOrderForUser:user items:redemptions callback:callback]; },
                                                                                                                                   SAFE_BLOCK(callback, [RNResponse responseWithError:error errorString:[self errorMessage:JSON] statusCode:response.statusCode]));
                                                                                 }];
    [self enqueueHTTPRequestOperation:op];
    
}

- (BOOL)wasSuccessful:(id)JSON {
    return JSON != nil && [JSON isKindOfClass:[NSDictionary class]] && (JSON[kErrorKey] == nil || JSON[kErrorKey] == [NSNull null]);
}

- (NSString *)errorMessage:(id)JSON {
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        return JSON[@"Error"][@"Description"];
    }
    return nil;
}

- (void)showLoginScreen:(RNAuthCallback)callback {
    
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if ([rootViewController presentedViewController]) {
        rootViewController = [rootViewController presentedViewController];
    }
    
    self.authCallback = callback;
    
    if (rootViewController != nil) {
        self.tipNumber = [[NSUserDefaults standardUserDefaults] stringForKey:BankCodeKey];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UINavigationController *controller = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"RNLoginViewController"];
        RNAuthViewController *auth = controller.viewControllers[0];
        auth.delegate = self;
        
        [rootViewController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)authViewController:(RNAuthViewController *)auth didFinish:(BOOL)success;
{
    
}

- (void)authViewControllerDidDismiss:(RNAuthViewController *)auth;
{
    if (self.authCallback != nil) {
        self.authCallback();
    }
}

#pragma mark - Base 64 Encoding

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

+ (NSString *)encodeBase64WithString:(NSString *)strData {
    return [self encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)encodeBase64WithData:(NSData *)objData {
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Create result NSString object
    NSString *base64String = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    
    // Free memory
    free(strResult);
    
    return base64String;
}


@end
