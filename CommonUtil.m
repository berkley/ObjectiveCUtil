//
//  CommonUtil.h
//
//  Created by Chad Berkley on 1/24/12.
//  
//  Anyone is free to use or distribute this code.  There is no warranty
//  or license.  You assume all risk in using this code.  It is made freely
//  available to whoever finds it useful
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (NSString*)formatDate:(NSDate*)date withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:format];
    NSString *d = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return d;
}

+ (id)getPath:(NSString*)path FromDictionary:(NSDictionary*)dict
{
    NSArray *strComp = [path componentsSeparatedByString:@"/"];
    NSDictionary *d = dict;
    NSString *pathElement;
    for(int i=0; i<[strComp count] - 1; i++)
    {
        pathElement = [strComp objectAtIndex:i];
        d = [d objectForKey:pathElement];
        if(d == nil || ![d isKindOfClass:[NSDictionary class]])
            return  nil;        
    }
    
    pathElement = [strComp objectAtIndex:[strComp count] - 1];
    NSObject *obj = [d objectForKey:pathElement];
    
    return obj; 
}

+ (NSString*)getStringFromPath:(NSString*)path FromDictionary:(NSDictionary*)dict
{
    NSObject *obj = [CommonUtil getPath:path FromDictionary:dict];
    if(obj == nil)
        return @"";
    else
        return (NSString*)obj;
}

+ (NSString*)getStringFromURLString:(NSString*)url
{
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] 
                                                 encoding:NSStringEncodingConversionAllowLossy 
                                                    error:&error];
    if(error != nil)
    {
        NSLog(@"ERROR getting url content: %@", [error localizedDescription]);
        return nil;
    }
    return  content;
}

+ (BOOL)fileExists:(NSString*)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL b = [fileManager fileExistsAtPath:filePath];
    return b;
}

+ (UIImage*)imageFromUrl:(NSString*)url
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}

+ (NSString*)getDataPathForFileWithName:(NSString*)filename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}

+ (void)writeString:(NSString*)data ToFile:(NSString*)filename
{
    NSError *error;
    if(![data writeToFile:[CommonUtil getDataPathForFileWithName:filename] 
               atomically:YES 
                 encoding:NSStringEncodingConversionAllowLossy 
                    error:&error])
    {
        NSLog(@"ERROR: Could not create the file: %@", filename);
    }
}

+ (NSString*)stringFromFrame:(CGRect)frame
{
    return [NSString stringWithFormat:@"x: %f y: %f w: %f h: %f", frame.origin.x, 
            frame.origin.y, frame.size.width, frame.size.height];
}

+ (void)zoomToFitMapAnnotations:(MKMapView*)mapView padding:(NSInteger)padding
{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - 
    (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + 
    (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - 
                                     bottomRightCoord.latitude) * padding; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - 
                                      topLeftCoord.longitude) * padding; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

+ (NSArray*)mergeArrayWithObjectContent:(NSArray*)a1 with:(NSArray*)a2
{
    //nil array cases
    if(a1 == nil && a2 == nil)
        return nil;
    else if(a1 == nil && a2 != nil)
        return a2;
    else if(a1 != nil && a2 == nil)
        return a1;
    
    //loop through, merge results removing duplicates
    NSMutableArray *results = [[[NSMutableArray alloc] initWithArray:a1] autorelease];
    for(int i=0; i<[a2 count]; i++)
    {
        id a = [a2 objectAtIndex:i];
        BOOL duplicate = NO;
        for(int j=0; j<[results count]; j++)
        {
            if(a == [results objectAtIndex:j])
            {
                duplicate = YES;
                break;
            }
        }
        if(!duplicate)
        {
            [results addObject:a];
        }
    }
    return results;
    
}

+ (NSArray*)mergeArrayResults:(NSArray*)a1 with:(NSArray*)a2
{
    //nil array cases
    if(a1 == nil && a2 == nil)
        return nil;
    else if(a1 == nil && a2 != nil)
        return a2;
    else if(a1 != nil && a2 == nil)
        return a1;
    
    //loop through, merge results removing duplicates
    NSMutableArray *results = [[[NSMutableArray alloc] initWithArray:a1] autorelease];
    for(int i=0; i<[a2 count]; i++)
    {
        NSString *a = [a2 objectAtIndex:i];
        BOOL duplicate = NO;
        for(int j=0; j<[results count]; j++)
        {
            if([a isEqualToString:[results objectAtIndex:j]])
            {
                duplicate = YES;
                break;
            }
        }
        if(!duplicate)
        {
            [results addObject:a];
        }
    }
    return results;
}

+ (BOOL)string:(NSString *)str startsWithStr:(NSString *)str2
{
    if([str rangeOfString:str2].location == NSNotFound)
        return NO;
    
    if([str rangeOfString:str2].location == 0 && [str rangeOfString:str2].length == [str2 length])
        return YES;
    
    return NO;
}

+ (BOOL)string:(NSString*)str containsStr:(NSString*)str2
{
    if(!str || !str2)
        return NO;
    
    if([str rangeOfString:str2].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (double)toRadians:(double)degrees
{
	return degrees * (M_PI / 180.0);
}

+ (BOOL)location:(CLLocation*)location isWithinProximity:(CGFloat)radius ofLocation:(CLLocation*)center
{
    double latRads = [CommonUtil toRadians:center.coordinate.latitude];
    
    double lonMin = center.coordinate.longitude - radius / abs(cos(latRads) * 69);
    double lonMax = center.coordinate.longitude + radius / abs(cos(latRads) * 69);
    
    double latMin = center.coordinate.latitude - (radius / 69);
    double latMax = center.coordinate.latitude + (radius / 69);
    
    if(location.coordinate.latitude > latMin && 
       location.coordinate.latitude < latMax &&
       location.coordinate.longitude > lonMin &&
       location.coordinate.longitude < lonMax)
    {
        return YES;
    }
    
    return NO;
}

+ (NSUInteger)zoomLevelForMapRect:(MKMapRect)mRect withMapViewSizeInPixels:(CGSize)viewSizeInPixels
{
    NSUInteger zoomLevel = MAXIMUM_ZOOM; // MAXIMUM_ZOOM is 20 with MapKit
    MKZoomScale zoomScale = mRect.size.width / viewSizeInPixels.width; //MKZoomScale is just a CGFloat typedef
    double zoomExponent = log2(zoomScale);
    zoomLevel = (NSUInteger)(MAXIMUM_ZOOM - ceil(zoomExponent));
    return zoomLevel;
}

+ (NSString*)stringFromUTF8:(char*)c
{
    if(c == nil)
        return @"";
    return [NSString stringWithUTF8String:c];
}

+ (NSInteger)zoomScaleToZoomLevel:(MKZoomScale)scale 
{
    double numTilesAt1_0 = MKMapSizeWorld.width / 256;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  
    // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

+ (float)getUILabelHeightByString:(NSString*)myString withFont:(UIFont*)font viewWidth:(int)myWidth
{
    CGSize boundingSize = CGSizeMake(myWidth, CGFLOAT_MAX);
    CGSize requiredSize = [myString sizeWithFont:font
                               constrainedToSize:boundingSize 
                                   lineBreakMode:UILineBreakModeWordWrap];  
    return requiredSize.height;
}

+ (NSString*)trimString:(NSString*)str
{
    if(str == nil)
        return nil;
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)replaceStringIfFound:(NSString*)removeStr withString:(NSString*)replaceStr fromString:(NSString*)str
{
    if([str rangeOfString:removeStr].location != NSNotFound)
        return [str stringByReplacingOccurrencesOfString:removeStr withString:replaceStr];
    return str;
}

+ (NSString*)removeStringIfFound:(NSString*)removeStr fromString:(NSString*)str
{
    if([str rangeOfString:removeStr].location != NSNotFound)
        return [str stringByReplacingOccurrencesOfString:removeStr withString:@""];
    return str;
}

+ (NSString*)removeItems:(NSArray*)items fromString:(NSString*)str
{
    for(NSString *removeStr in items)
        str = [CommonUtil removeStringIfFound:removeStr fromString:str];
    return str;
}

+ (BOOL)stringNullOrEmpty:(NSString*)str
{
    if(str != nil)
    {
        NSString *s = [CommonUtil trimString:str];
        if([s isEqualToString:@""])
            return YES;
        else
            return NO;
    }
    else
        return YES;
}

+ (NSArray*)createGreatCircleArrayFromPoint:(CLLocationCoordinate2D)point1 
                                    toPoint:(CLLocationCoordinate2D)point2 
                        totalNumberSegments:(int)numsegs 
                        numSegmentsToReturn:(int)retNumSeg
{
    //mathematics taken from http://williams.best.vwh.net/avform.htm#Crs
    NSMutableArray *coords = [[[NSMutableArray alloc] initWithCapacity:retNumSeg + 2] autorelease];
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;
    //convert to rad
    lat1 = lat1 * (M_PI/180);
    lon1 = lon1 * (M_PI/180);
    lat2 = lat2 * (M_PI/180);
    lon2 = lon2 * (M_PI/180);
    double d = 2 * asin( sqrt(pow(( sin( (lat1-lat2)/2) ), 2) + 
                              cos(lat1) * 
                              cos(lat2) * 
                              pow(( sin( (lon1-lon2)/2) ), 2)));
    double f = 0.0;
    CLLocation *point1Loc = [[CLLocation alloc] initWithLatitude:point1.latitude longitude:point1.longitude];
    [coords addObject:point1Loc];
    [point1Loc release];
    if(numsegs < retNumSeg)
        retNumSeg = numsegs;
    for(int i=2; i<=retNumSeg; i++)
    {
        f += 1.0 / (float)numsegs;
        double A = sin((1 - f) * d) / sin(d);
        double B = sin(f * d) / sin(d);
        double x = A * cos(lat1) * cos(lon1) +  B * cos(lat2) * cos(lon2);
        double y = A * cos(lat1) * sin(lon1) +  B * cos(lat2) * sin(lon2);
        double z = A * sin(lat1)             +  B * sin(lat2);
        //calc lat/lon in rad
        double latr = atan2(z, sqrt(pow(x, 2) + pow(y, 2) ));
        double lonr = atan2(y, x);
        //convert back to degrees
        double lat = latr * (180/M_PI);
        double lon = lonr * (180/M_PI);
        //        NSLog(@"lat: %f lon: %f", lat, lon);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        [coords addObject:loc];
        [loc release];
    }
    
    if(retNumSeg == numsegs)
    { //add point2 as the last point iff retNumSeg isn't < numsegs
        CLLocation *point2Loc = [[CLLocation alloc] initWithLatitude:point2.latitude longitude:point2.longitude];
        [coords addObject:point2Loc];
        [point2Loc release];
    }
    
    return coords;
}

+ (CLLocationCoordinate2D*)createGreatCirclePointsFromPoint:(CLLocationCoordinate2D)point1 
                                                    toPoint:(CLLocationCoordinate2D)point2 
                                             numberSegments:(int)numsegs
{
    //mathematics taken from http://williams.best.vwh.net/avform.htm#Crs
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;
    //convert to rad
    lat1 = lat1 * (M_PI/180);
    lon1 = lon1 * (M_PI/180);
    lat2 = lat2 * (M_PI/180);
    lon2 = lon2 * (M_PI/180);
    double d = 2 * asin( sqrt(pow(( sin( (lat1-lat2)/2) ), 2) + 
                              cos(lat1) * 
                              cos(lat2) * 
                              pow(( sin( (lon1-lon2)/2) ), 2)));
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * (numsegs + 2));
    double f = 0.0;
    coords[0] = point1;
    for(int i=2; i<=numsegs; i++)
    {
        f += 1.0 / (float)numsegs;
        double A = sin((1 - f) * d) / sin(d);
        double B = sin(f * d) / sin(d);
        double x = A * cos(lat1) * cos(lon1) +  B * cos(lat2) * cos(lon2);
        double y = A * cos(lat1) * sin(lon1) +  B * cos(lat2) * sin(lon2);
        double z = A * sin(lat1)             +  B * sin(lat2);
        //calc lat/lon in rad
        double latr = atan2(z, sqrt(pow(x, 2) + pow(y, 2) ));
        double lonr = atan2(y, x);
        //convert back to degrees
        double lat = latr * (180/M_PI);
        double lon = lonr * (180/M_PI);
        //        NSLog(@"lat: %f lon: %f", lat, lon);
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
        coords[i - 1] = loc;
    }
    coords[numsegs + 2] = point2;
    return coords;
}

+ (void)createGreatCircleMKPolylineFromPoint:(CLLocationCoordinate2D)point1 
                                     toPoint:(CLLocationCoordinate2D)point2
                                  forMapView:(MKMapView*)mapView
{
    //draw great circle route
    int numsegs = 100;
    CLLocationCoordinate2D *coords = [CommonUtil createGreatCirclePointsFromPoint:point1 
                                                                            toPoint:point2 
                                                                     numberSegments:numsegs];
    
    //check for circling west to east. If the plane is crossing 180, we need
    //to draw two lines or else the polyline connects the dots and draws a straight
    //line all the way across the map.
    CLLocationCoordinate2D prevCoord;
    BOOL twoLines = NO;
    int numsegs2 = 0;
    CLLocationCoordinate2D *coords2;
    
    for(int i=0; i<numsegs; i++)
    {
        CLLocationCoordinate2D coord = coords[i];
        if(prevCoord.longitude < -170 && prevCoord.longitude > -180  && prevCoord.longitude < 0 
           && coord.longitude > 170 && coord.longitude < 180 && coord.longitude > 0)
        {
            twoLines = YES;
            coords2 = malloc(sizeof(CLLocationCoordinate2D) * (numsegs - i));
            numsegs2 = numsegs - i;
            for(int j=0; j<numsegs2; j++)
            {
                coords2[j] = coords[i + j];
            }
            break;
        }
        prevCoord = coord;
    }
    
    //remove any previously added overlays
    [mapView removeOverlays:mapView.overlays];
    
    if(twoLines)
    {
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:numsegs - numsegs2];
        [mapView addOverlay:polyline];
        
        MKPolyline *polyline2 = [MKPolyline polylineWithCoordinates:coords2 count:numsegs2];
        [mapView addOverlay:polyline2];
        
        free(coords2);
    }
    else
    {
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:numsegs];
        [mapView addOverlay:polyline];
    }
    
    free(coords);
}

+ (NSString*)displayCurrentDateForTimezone:(NSTimeZone*)timezone withFormat:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    [formatter setDateFormat:format];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    [formatter release];
    return currentDateStr;
}

+ (NSString*)displayCurrentDateForTimezone:(NSTimeZone*)timezone
{
    return [CommonUtil displayCurrentDateForTimezone:timezone withFormat:@"yyyy-MM-dd HH:mm ZZZZ"];
}

+ (CGRect)updatePart:(NSInteger)part OfRect:(CGRect)rect withValue:(CGFloat)val
{
    switch (part) {
        case CGRECT_PART_X:
            return CGRectMake(val, rect.origin.y, rect.size.width, rect.size.height);
            break;
        case CGRECT_PART_Y:
            return CGRectMake(rect.origin.x, val, rect.size.width, rect.size.height);
            break;
        case CGRECT_PART_W:
            return CGRectMake(rect.origin.x, rect.origin.y, val, rect.size.height);
            break;
        case CGRECT_PART_H:
            return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, val);
            break;
        default:
            return rect;
            break;
    }
}

@end
