

#import "NSObject+CSAPI.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "CSAPIBoolMapper.h"
#import "CSJoinMapper.h"
#import "CSCountMapper.h"


static NSString * const ATLMappingParentKey = @"__parent__";
static NSString * const ATLMappingKeyKey = @"key";
static NSString * const ATLMappingClassKey = @"type";
static NSString * const ATLMappingMapperKey = @"mapper";
static NSString * const ATLMappingDefaultKey = @"default";


@implementation NSObject (CSAPI)


/**
 Maps data from aDictionary according to a given .plist file whose name matches
 the name of the class.
 
 There are 3 different options to this. You can just specify the attribute "key"
 inside the plist per attribute. Which is the mapping.
 
 Example:
 testBlah: {
 key: test_key
 }
 
 would map aDictionary['test_key'] to testBlah.
 
 If you specify 'type' as well, a given type will be enforced.
 There are built in types and custom types, like CSBool which serve as an
 adapter for NSNumber bools that get returned as "on", "true", "1" etc.
 
 If you specify 'mapper', a class that implements CSMapper is used to do
 the transformation by calling transformValue.
 
 If you specify 'type' and 'mapper', the 'type' is applied first before
 the value gets sent to the mapper.
 */


- (void)mapAttributesFromDictionary:(NSDictionary *)aDictionary {
	[self mapAttributesFromDictionary:(NSDictionary *)aDictionary mappingPostFix:nil];
}

- (void)mapAttributesFromDictionary:(NSDictionary *)aDictionary mappingPostFix:(NSString*)postFix {

	NSString *mappingString = NSStringFromClass([self class]);

	if (postFix){
		mappingString = [mappingString stringByAppendingFormat:@"%@", postFix];
	}
	//NSLog(@"Mapping String %@", mappingString);
	NSDictionary *mapping = [[self class] mappingForEntity:mappingString];
	
	if ([[mapping allKeys] count] == 0) {
		mappingString = NSStringFromClass([self class]);
		mapping = [[self class] mappingForEntity:mappingString];
	
		//NSLog(@"Failed Mapping String %@", mappingString);
	}

	id key = nil;
	NSDictionary *propertyMapping = nil;
	id inputValue = nil;
	id outputValue = nil;
	id subValue = nil;
	Class forcedClass = nil;
	NSString *forcedClassString = nil;
	Class mapperClass = nil;
	SEL selector = nil;
	
	for (NSString *propertyName in mapping) {
		if (![propertyName isEqualToString:ATLMappingParentKey]) {
			propertyMapping = [mapping objectForKey:propertyName];
			
			forcedClassString = [propertyMapping objectForKey:ATLMappingClassKey];
			forcedClass = NSClassFromString(forcedClassString);
			mapperClass = NSClassFromString([propertyMapping objectForKey:ATLMappingMapperKey]);
			
			key = [propertyMapping objectForKey:ATLMappingKeyKey];
			// If key is array, try the fetch all values for input value
			if ([key isKindOfClass:[NSString class]]) {
				inputValue = [aDictionary valueForKeyPath:key];
				if (inputValue == nil) {
					// Try getting the default.
					inputValue = [propertyMapping objectForKey:ATLMappingDefaultKey];
					if (inputValue == nil) {
						continue;
					}
				}
			} else if ([key isKindOfClass:[NSArray class]]) {
				inputValue = [NSMutableArray arrayWithCapacity:[key count]];
				for (id subKey in key) {
					
					if ([subKey isKindOfClass:[NSDictionary class]]) {
						subValue = [aDictionary valueForKeyPath:[subKey valueForKey:ATLMappingKeyKey]];
						
						if (subValue == nil) {
							subValue = [subKey valueForKey:ATLMappingDefaultKey];
							[inputValue addObject:subValue];
						} else {
							[inputValue addObject:subValue];
						}
						
					} else {
						subValue = [aDictionary valueForKeyPath:subKey];
						
						if (subValue != nil) {
							[inputValue addObject:subValue];
						}
					}
				}
				
				if ([inputValue count] == 0) {
					continue;
				}
			}
			
			outputValue = inputValue;
			if (forcedClass && ![inputValue isKindOfClass:forcedClass]) {
				selector = NSSelectorFromString([NSString stringWithFormat:@"%@Value", forcedClass]);
				if ([inputValue respondsToSelector:selector]) {
					// Try to use the built in conversion features for known types
					outputValue = objc_msgSend(inputValue, selector);
				} else {
					// Try to map unknown type with same technique.
					id newValue = [[forcedClass alloc] init];
					[newValue mapAttributesFromDictionary:inputValue];
					outputValue = newValue;
				}
			}
			
			if (mapperClass && mapperClass) {
				outputValue = [(id<CSMapper>)mapperClass transformValue:inputValue];
			}
			
			[self setValue:outputValue forKey:propertyName];
		}
	}
}


/**
 Finds the .plist file for an entityKey
 */
+ (NSDictionary *)mappingForEntity:(NSString *)entityKey {
    // Rocco: adding cheapo in-memory caching to improve performance
    static NSMutableDictionary * inMemoryCache = NULL;
    if(inMemoryCache == NULL)
        inMemoryCache = [NSMutableDictionary dictionary];
    
    id cached = [inMemoryCache objectForKey:entityKey];
    if(cached)
        return cached;
    // Rocco: End cheapo in-memory caching
    
	NSDictionary *mapping = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:entityKey ofType:@"plist"]];
	
	id parentEntityMapping = [mapping objectForKey:ATLMappingParentKey];
	NSArray *parents;
	if ([parentEntityMapping isKindOfClass:[NSArray class]]) {
		parents = parentEntityMapping;
	} else if (parentEntityMapping != nil) {
		parents = [NSArray arrayWithObject:parentEntityMapping];
	}
	
	NSMutableDictionary *mappingResult = [NSMutableDictionary dictionary];
	for (NSString *parent in parents) {
		[mappingResult addEntriesFromDictionary:[[self class] mappingForEntity:parent]];
	}
	
	[mappingResult addEntriesFromDictionary:mapping];
    
    [inMemoryCache setObject:mappingResult forKey:entityKey];
	
	return mappingResult;
}


/**
 Converts an object into an NSNumber
 */
- (NSNumber *)NSNumberValue {
	if ([self isKindOfClass:[NSString class]]) {
		NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber *retval = [f numberFromString:(NSString *)self];
		
		return retval;
	} else if ([self isKindOfClass:[NSNumber class]]) {
		
		return (NSNumber *)self;
	} else {
		
		//LOG_G(@"%@ could not be converted to NSNumber", self);
		return nil;
	}
}


/**
 Converts an object into an NSString
 */
- (NSString *)NSStringValue {
	if ([self isKindOfClass:[NSObject class]]) {
		NSString *retval = [self description];
		
		return retval;
	}
	
	return nil;
}



+ (id)valueForProperty:(NSString *)propertyName fromDictionary:(NSDictionary *)aDictionary {
	return [NSObject valueForProperty:propertyName fromDictionary:aDictionary mappingPostFix:nil];
}


+ (id)valueForProperty:(NSString *)propertyName fromDictionary:(NSDictionary *)aDictionary mappingPostFix:(NSString*)postFix {
	
	NSString *mappingString = NSStringFromClass([self class]);
	
	if (postFix){
		mappingString = [mappingString stringByAppendingFormat:@"%@", postFix];
	}
	//NSLog(@"Mapping String %@", mappingString);
	NSDictionary *mapping = [[self class] mappingForEntity:mappingString];
	
	if ([[mapping allKeys] count] == 0) {
		mappingString = NSStringFromClass([self class]);
		mapping = [[self class] mappingForEntity:mappingString];
		
		//NSLog(@"Failed Mapping String %@", mappingString);
	}
	
	//NSString *class = NSStringFromClass([self class]);
	//NSDictionary *mapping = [[self class] mappingForEntity:class];
	
		
//	mapping = [[self class] mappingForEntity:mappingString];
	
	id key = nil;
	NSDictionary *propertyMapping = nil;
	id inputValue = nil;
	id outputValue = nil;
	id subValue = nil;
	Class forcedClass = nil;
	NSString *forcedClassString = nil;
	Class mapperClass = nil;
	SEL selector = nil;
	
	propertyMapping = [mapping objectForKey:propertyName];
	
	forcedClassString = [propertyMapping objectForKey:ATLMappingClassKey];
	forcedClass = NSClassFromString(forcedClassString);
	mapperClass = NSClassFromString([propertyMapping objectForKey:ATLMappingMapperKey]);
	
	key = [propertyMapping objectForKey:ATLMappingKeyKey];
	// If key is array, try the fetch all values for input value
	if ([key isKindOfClass:[NSString class]]) {
		inputValue = [aDictionary valueForKeyPath:key];
		if (inputValue == nil) {
			// Try getting the default.
			inputValue = [propertyMapping objectForKey:ATLMappingDefaultKey];
			if (inputValue == nil) {
				return nil;
			}
		}
	} else if ([key isKindOfClass:[NSArray class]]) {
		inputValue = [NSMutableArray arrayWithCapacity:[key count]];
		for (id subKey in key) {
			
			if ([subKey isKindOfClass:[NSDictionary class]]) {
				subValue = [aDictionary valueForKeyPath:[subKey valueForKey:ATLMappingKeyKey]];
				
				if (subValue == nil) {
					subValue = [subKey valueForKey:ATLMappingDefaultKey];
					[inputValue addObject:subValue];
				} else {
					[inputValue addObject:subValue];
				}
				
			} else {
				subValue = [aDictionary valueForKeyPath:subKey];
				
				if (subValue != nil) {
					[inputValue addObject:subValue];
				}
			}
		}
		
		if ([inputValue count] == 0) {
			return nil;
		}
	}
	
	outputValue = inputValue;
	if (forcedClass && ![inputValue isKindOfClass:forcedClass]) {
		selector = NSSelectorFromString([NSString stringWithFormat:@"%@Value", forcedClass]);
		if ([inputValue respondsToSelector:selector]) {
			// Try to use the built in conversion features for known types
			outputValue = objc_msgSend(inputValue, selector);
		} else {
			// Try to map unknown type with same technique.
			id newValue = [[forcedClass alloc] init];
			[newValue mapAttributesFromDictionary:inputValue];
			outputValue = newValue;
		}
	}
	
	if (mapperClass && mapperClass) {
		outputValue = [(id<CSMapper>)mapperClass transformValue:inputValue];
	}
	
	return outputValue;
}


@end

