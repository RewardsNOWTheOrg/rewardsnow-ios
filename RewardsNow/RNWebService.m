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

NSString *const kPBaseURL = @"https://api.rewardsnow.com/qa/";
NSString *const kPAPISecret = @"f7ceef815c71ce92b613a841581f641d5982cba6fa2411c3eb07bc74d5bc081";

NSString *const kResultsKey = @"Result";
NSString *const kErrorKey = @"Error";
NSString *const kStatementKey = @"Statement";
NSString *const kOffersKey = @"Offers";

@interface RNWebService()

@property (nonatomic, strong) NSString *authorizationHeader;

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

- (void)getDealsAtLocation:(CLLocation *)location query:(NSString *)query callback:(RNResultCallback)callback {
    [self getDealsAtLocation:location query:query limit:20 offset:0 radius:15.0 category:nil callback:callback];
}

- (void)getSecretQuestionWithCallback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSString *url = [NSString stringWithFormat:@"StsService.svc/GetSecretQuestion/%@", _tipNumber];
    
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
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:url parameters:nil];
    [request setAllHTTPHeaderFields:@{@"X-RNI-ApiKey": kPAPISecret, @"Accept": @"application/json"}];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"Response: %@", JSON);
                                                                                     
                                                                                     if ([self wasSuccessful:JSON]) {
                                                                                         RNBranding *branding = [RNBranding sharedBrandingFromDictionary:[JSON objectForKey:@"Brandings"]];
                                                                                         callback(branding);
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
    
    NSString *url = [NSString stringWithFormat:@"FacadeService.svc/GetCart/%@/0", _tipNumber];
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
                                                                                         self.authorizationHeader = JSON[@"LoginResult"][@"Token"];
                                                                                         [self setDefaultHeader:@"Authorization" value:self.authorizationHeader];
                                                                                         self.tipNumber = [JSON[@"LoginResult"][@"Tipnumber"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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

- (void)postResetPasswordWithAnswer:(NSString *)answer password:(NSString *)password passwordConfirm:(NSString *)confirmed username:(NSString *)username fullName:(NSString *)fullName callback:(RNResultCallback)callback {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipNumber": _tipNumber,
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

- (void)postChangePasswordWithUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword callback:(RNResultCallback)callback {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"tipNumber": _tipNumber,
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

- (void)postPlaceOrderForUser:(RNUser *)user items:(NSArray *)redemptions  callback:(RNResultCallback)callback {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    /*
     {
     "tipnumber":"969999999999999",
     "Redemptions":[ { "Item":"EGC-LLBEAN", "Quantity":"1" } ],
     "CustomerEmail":"ssmith@rewardsnow.com",
     "saddress1":"380 Central Ave",
     "saddress2":"Suite 350",
     "scity":"Dover",
     "sstate":"NH",
     "szipcode":"03820",
     "scountry":"USA",
     "hphone":"603-516-3440",
     "wphone":""
     }
     
     */
    
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
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"FacadeService.svc/PlaceOrder" parameters:nil];
    [request setHTTPBody:data];
    
    DLog(@"Request: %@",  request);
    DLog(@"Request1: %@",  request.allHTTPHeaderFields);
    DLog(@"Request2: %@",  postParameters);
    
    DLog(@"What we sent: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                     [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                     
                                                                                     DLog(@"JSON: %@", JSON);
                                                                                     
                                                                                     if ([JSON[@"PlaceOrderResult"] boolValue]) {
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
    return JSON != nil && [JSON isKindOfClass:[NSDictionary class]] && (JSON[kErrorKey] == nil || JSON[kErrorKey] == [NSNull null]);
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
