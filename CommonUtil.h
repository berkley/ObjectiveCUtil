//
//  CommonUtil.h
//
//  Created by Chad Berkley on 1/24/12.
//  
//  Anyone is free to use or distribute this code.  There is no warranty
//  or license.  You assume all risk in using this code.  It is made freely
//  available to whomever finds it useful
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "math.h"

#define _USE_MATH_DEFINES
#define MAXIMUM_ZOOM 20
#define MAP_DEFAULT_SPAN 300000

@interface CommonUtil : NSObject

//format a date to a string using the given format
+ (NSString*)formatDate:(NSDate*)date withFormat:(NSString*)format;

//translate a '/' delimited path to get a value from a nested dictionary
//returns nil if the path is not found
+ (id)getPath:(NSString*)path FromDictionary:(NSDictionary*)dict;

//translate a '/' delimited path to get a value from a nested dictionary
//returns @"" if the path is not found
+ (NSString*)getStringFromPath:(NSString*)path FromDictionary:(NSDictionary*)dict;

//return the string response from a string formatted url
+ (NSString*)getStringFromURLString:(NSString*)url;

//return true if a file exists at the given path
+ (BOOL)fileExists:(NSString*)filePath;

//get a UIImage from a url string
+ (UIImage*)imageFromUrl:(NSString*)url;

//find the documents directory for the app and return the path + the filename
+ (NSString*)getDataPathForFileWithName:(NSString*)filename;

//write data to a file with the given filename
+ (void)writeString:(NSString*)data ToFile:(NSString*)filename;

//return a string with the frame params.  Useful for debugging.
+ (NSString*)stringFromFrame:(CGRect)frame;

//zoom a map to fit the set annotations
+ (void)zoomToFitMapAnnotations:(MKMapView*)mapView padding:(NSInteger)padding;

//merge arrays removing duplicates with an object comparison
+ (NSArray*)mergeArrayWithObjectContent:(NSArray*)a1 with:(NSArray*)a2;

//merge multiple arrays into one doing a string comparison. These arrays must
//contain strings
+ (NSArray*)mergeArrayResults:(NSArray*)a1 with:(NSArray*)a2;

//returns YES if str starts with str2
+ (BOOL)string:(NSString *)str startsWithStr:(NSString *)str2;

//return YES if str contains str2 (similar to java String.indexOf() function)
+ (BOOL)string:(NSString*)str containsStr:(NSString*)str2;

//convert degress to radians
+ (double)toRadians:(double)degrees;

//Geo proximity query using the Haversine Equation. Proximity in miles
//http://blog.fedecarg.com/2009/02/08/geo-proximity-search-the-haversine-equation/
+ (BOOL)location:(CLLocation*)location isWithinProximity:(CGFloat)radius ofLocation:(CLLocation*)center;

//return the zoom level for the given map rect and size of the mapview
+ (NSUInteger)zoomLevelForMapRect:(MKMapRect)mRect withMapViewSizeInPixels:(CGSize)viewSizeInPixels;

//return a string from a UTF8 char array
+ (NSString*)stringFromUTF8:(char*)c;

//convert zoom scale to zoom level for a map
+ (NSInteger)zoomScaleToZoomLevel:(MKZoomScale)scale;

//returns the height of a UILabel based on the content of the label, the font and the width of the view
+ (float)getUILabelHeightByString:(NSString*)myString withFont:(UIFont*)font viewWidth:(int)myWidth;

//trim white space chars from str
+ (NSString*)trimString:(NSString*)str;

//replace one string with another if it's found.
+ (NSString*)replaceStringIfFound:(NSString*)removeStr withString:(NSString*)replaceStr fromString:(NSString*)str;

//remove a string if it's found
+ (NSString*)removeStringIfFound:(NSString*)removeStr fromString:(NSString*)str;

//remove a string from multiple strings
+ (NSString*)removeItems:(NSArray*)items fromString:(NSString*)str;

//return YES if a string is nil or empty (@"").  The string is trimmed, so @" " will return YES
+ (BOOL)stringNullOrEmpty:(NSString*)str;

//creates an array of retNumSeg points on a great circle arc from point1 to point2.
//if numsegs != retNumSegs, it will return the first retNumSegs of the arc, but
//still calculate the line with numsegs points.
+ (NSArray*)createGreatCircleArrayFromPoint:(CLLocationCoordinate2D)point1 
                                    toPoint:(CLLocationCoordinate2D)point2 
                        totalNumberSegments:(int)numsegs 
                        numSegmentsToReturn:(int)retNumSeg;

//create an array of CLLocationCoordinate2D from point1 to point2 with numsegs points.
+ (CLLocationCoordinate2D*)createGreatCirclePointsFromPoint:(CLLocationCoordinate2D)point1 
                                                    toPoint:(CLLocationCoordinate2D)point2 
                                             numberSegments:(int)numsegs;

//draw a great circle path from point1 to point2 on mapView
+ (void)createGreatCircleMKPolylineFromPoint:(CLLocationCoordinate2D)point1 
                                     toPoint:(CLLocationCoordinate2D)point2
                                  forMapView:(MKMapView*)mapView;

@end
