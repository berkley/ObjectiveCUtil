//
//  SunriseAndSunset.h
//
//  Created by Chad Berkley on 1/24/12.
//

#import <Foundation/Foundation.h>
#import "sunriset.h"

@interface SunriseAndSunset : NSObject

+ (BOOL)isDarkAtLat:(double)lat lon:(double)lon atTime:(NSDate*)now timezone:(NSTimeZone*)tz;
+ (NSDate*)sunsetForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)timezone;
+ (NSDate*)sunriseForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)timezone;
+ (NSDictionary*)sunriseAndSetForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)tz;

@end
