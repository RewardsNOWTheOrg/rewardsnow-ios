//
//  RNLocalDeal.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/1/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalDeal.h"
#import <AddressBook/AddressBook.h>

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

+ (NSValueTransformer *)websiteJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (NSURL *)phoneURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNumber]];
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

- (CLLocationCoordinate2D)coordinate2D {
    
    return CLLocationCoordinate2DMake(_latitude.doubleValue, _longitude.doubleValue);
}

- (NSDictionary *)addressDictionary {

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (_address != nil) [dictionary setValue:_address forKey:(NSString *)kABPersonAddressStreetKey];
    if (_country != nil) [dictionary setValue:_country forKey:(NSString *)kABPersonAddressCountryKey];
    if (_state != nil) [dictionary setValue:_state forKey:(NSString *)kABPersonAddressStreetKey];
    if (_zipCode != nil) [dictionary setValue:_zipCode forKey:(NSString *)kABPersonAddressZIPKey];
    return dictionary;
}

@end
