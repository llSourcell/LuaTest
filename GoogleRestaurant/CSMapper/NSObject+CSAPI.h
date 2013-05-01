//
//  NSObject+CSAPI.h
//  CSMapper
//
//  Created by Marc Ammann on 4/30/12.
//  Copyright (c) 2012 Marc Ammann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMapper.h"


@interface NSObject (CSAPI)

- (void)mapAttributesFromDictionary:(NSDictionary *)aDictionary;
- (void)mapAttributesFromDictionary:(NSDictionary *)aDictionary mappingPostFix:(NSString*)postFix;
+ (NSDictionary *)mappingForEntity:(NSString *)entityKey;
+ (id)valueForProperty:(NSString *)key fromDictionary:(NSDictionary *)aDictionary;
+ (id)valueForProperty:(NSString *)propertyName fromDictionary:(NSDictionary *)aDictionary mappingPostFix:(NSString*)postFix;
@end
