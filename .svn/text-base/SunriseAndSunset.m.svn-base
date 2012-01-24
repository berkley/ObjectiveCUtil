//
//  SunriseAndSunset.m
//
//  Created by Chad Berkley on 1/24/12.
//
//  Anyone is free to use or distribute this code.  There is no warranty
//  or license.  You assume all risk in using this code.  It is made freely
//  available to whoever finds it useful.

#import "SunriseAndSunset.h"

@implementation SunriseAndSunset

+ (NSDictionary*)sunriseAndSetForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)tz
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit | 
                                                              NSMonthCalendarUnit | 
                                                              NSYearCalendarUnit ) 
                                                    fromDate:date];
    NSInteger theDay = [dateComponents day];
    NSInteger theMonth = [dateComponents month];
    NSInteger theYear = [dateComponents year];
    int tzOffset = [tz secondsFromGMT] / 3600;
    
    double rise;
    double set;
    
    sun_rise_set(theYear, theMonth, theDay, lon, lat, &rise, &set);
    int hours = HOURS(rise) + tzOffset;
    int mins = MINUTES(rise);
    int sethrs = HOURS(set) + tzOffset;
    int setmins = MINUTES(set);
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm ZZZZ"];
    NSString *dateStr = [NSString stringWithFormat:@"%i-%2d-%2d %2d:%2d %@", theYear, theMonth, theDay, hours, mins, tz.name];
    NSDate *d = [formatter dateFromString:dateStr];
    
    dateStr = [NSString stringWithFormat:@"%i-%2d-%2d %2d:%2d %@", theYear, theMonth, theDay, sethrs, setmins, tz.name];
    NSDate *d2 = [formatter dateFromString:dateStr];
    [formatter release];
    [gregorian release];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:d, @"sunrise", d2, @"sunset", nil];
}

+ (NSDate*)sunriseForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)timezone
{
    return [[SunriseAndSunset sunriseAndSetForDate:date lat:lat lon:lon timezone:(NSTimeZone*)timezone] objectForKey:@"sunrise"];
}

+ (NSDate*)sunsetForDate:(NSDate*)date lat:(double)lat lon:(double)lon timezone:(NSTimeZone*)timezone
{
    return [[SunriseAndSunset sunriseAndSetForDate:date lat:lat lon:lon timezone:(NSTimeZone*)timezone] objectForKey:@"sunset"];
}

//returns true if the current time is after sunrise and before sunset
+ (BOOL)isDarkAtLat:(double)lat lon:(double)lon atTime:(NSDate*)now timezone:(NSTimeZone*)tz
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm ZZZZ"];
    
    NSDate *sunrise = [SunriseAndSunset sunriseForDate:now lat:lat lon:lon timezone:tz];
    NSDate *sunset = [SunriseAndSunset sunsetForDate:now lat:lat lon:lon timezone:tz];
    //    NSLog(@"sunrise: %@ sunset: %@ now: %@", [formatter stringFromDate:sunrise], 
    //          [formatter stringFromDate:sunset], [formatter stringFromDate:now]);
    NSComparisonResult sunriseComp = [now compare:sunrise];
    NSComparisonResult sunsetComp = [now compare:sunset];
    [formatter release];
    if(sunriseComp == NSOrderedAscending) //before sunrise
        return YES;
    if(sunsetComp == NSOrderedDescending) //after sunset
        return YES;
    return NO;
}

@end
