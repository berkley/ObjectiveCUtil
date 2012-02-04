//
//  SunriseAndSunset.h
//
//  Created by Chad Berkley on 1/24/12.
//
//  Anyone is free to use or distribute this code.  There is no warranty
//  or license.  You assume all risk in using this code.  It is made freely
//  available to whoever finds it useful.

#import <Foundation/Foundation.h>
#import "sunriset.h"

@interface SunriseAndSunset : NSObject

//return YES if the sun has set at lat/lon at the given time in the given timezone
+ (BOOL)isDarkAtLat:(double)lat lon:(double)lon atTime:(NSDate*)now timezone:(NSTimeZone*)tz;

//return the NSDate when the sun sets at the given location and timezone
+ (NSDate*)sunsetForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)timezone;

//return the NSDate when the sun rises at the given location and timezone
+ (NSDate*)sunriseForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)timezone;

//return both sunset and sunrise at the given location and timezone
+ (NSDictionary*)sunriseAndSetForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)tz;

@end
