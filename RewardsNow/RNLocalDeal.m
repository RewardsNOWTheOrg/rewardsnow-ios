//
//  RNLocalDeal.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/1/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalDeal.h"

@implementation RNLocalDeal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"ActiveFrom" forKey:@"activeFrom"];
    [fields setValue:@"ActiveTo" forKey:@"activeTo"];
    [fields setValue:@"AdditionalInfo" forKey:@"additionalInformation"];
    [fields setValue:@"Address" forKey:@"address"];
    [fields setValue:@"BusinessName" forKey:@"businessName"];
    [fields setValue:@"Country" forKey:@"country"];
    [fields setValue:@"Description" forKey:@"localDealDescription"];
    [fields setValue:@"Discount" forKey:@"discountString"];
    [fields setValue:@"DiscountValue" forKey:@"discountValue"];
    [fields setValue:@"IdOffer" forKey:@"offerID"];
    [fields setValue:@"Image" forKey:@"imageURL"];
    [fields setValue:@"Latitude" forKey:@"latitude"];
    [fields setValue:@"Longitude" forKey:@"longitude"];
    [fields setValue:@"Name" forKey:@"name"];
    [fields setValue:@"Phone" forKey:@"phoneNumber"];
    [fields setValue:@"State" forKey:@"state"];
    [fields setValue:@"WebSite" forKey:@"website"];
    [fields setValue:@"ZipCode" forKey:@"zipCode"];
    return fields;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (CLLocation *)location {
    if (_location == nil) {
        _location = [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
    }
    return _location;
}

- (NSString *)discountAsString {
    return [NSString stringWithFormat:@"%@ Discount!", _discountString];
}

@end
