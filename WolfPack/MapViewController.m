//
//  MapViewController.m
//  Photomania
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "MapViewController.h"
#import "WolfAnnotationView.h"

@interface MapViewController ()
@end

@implementation MapViewController

// sets up self as the MKMapView's delegate
// notes (one time only) that we should zoom in on our annotations

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.needUpdateRegion = YES;
    self.mapView.showsUserLocation=false;
    
}

// when someone touches on a pin, this gets called
// all it does is set the thumbnail (if the annotation has one)
//   in the leftCalloutAccessoryView (if that is a UIImageView)

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   /* if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(thumbnail)]) {
            // this should be done in a different thread!
            imageView.image = [view.annotation performSelector:@selector(thumbnail)];
        }
    }*/
}




- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSNumber *latitude = [[NSNumber alloc] initWithDouble:userLocation.location.coordinate.latitude ];
    NSNumber *longitude = [[NSNumber alloc] initWithDouble:userLocation.location.coordinate.longitude ];
    NSArray *array = @[latitude ,longitude];
    if (userLocation.location.horizontalAccuracy > 0) {
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)];
        
        [[NSUserDefaults standardUserDefaults] setValue:array forKey:@"current_coordinates"];
    }
    
}


// the MKMapView calls this to get the MKAnnotationView for a given id <MKAnnotation>
// our implementation returns a standard MKPinAnnotation
//   which has callouts enabled
//   and which has a leftCalloutAccessory of a UIImageView
//   and a rightCalloutAccessory of a detail disclosure button
//     (but only if delegate responds to mapView:annotationView:calloutAccessoryControlTapped:)

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"MapViewController";
    WolfAnnotationView *view = (WolfAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    
    if (!view) {
        if (![annotation isKindOfClass:MKUserLocation.class]) {
            WolfAnnotationView *wolfView = [[WolfAnnotationView alloc] initWithFrame:CGRectMake(0,0,50,50) andAnnotation:annotation withReuseId:reuseId];
            
            wolfView.radius = 100;
            wolfView.annotation = annotation;
            wolfView.friend = (Friend*)annotation;
            [wolfView showSmallView];
            view  = wolfView;
            
        }else{
            // this is the current location annotation
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            
        }
        /*
         if ([annotation coordinate].latitude == [(NSNumber *)[coords objectAtIndex:0] doubleValue] && [annotation coordinate].longitude ==[(NSNumber *)[coords objectAtIndex:1] doubleValue] ) {
         
         // this is the current location annotation
         view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
         
         
         }else{
         WolfAnnotationView *wolfView = [[WolfAnnotationView alloc] initWithFrame:CGRectMake(0,0,30,30) andAnnotation:annotation withReuseId:reuseId];
         wolfView.radius = 120;
         wolfView.annotation = annotation;
         wolfView.friend = (Friend*)annotation;
         view  = wolfView;
         
         }
         */

    }
    view.annotation = annotation;
    [(WolfAnnotationView*)view showSmallView];
    return view;
}

// after we have appeared, zoom in on the annotations (but only do that once)

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateRegion];
    
}

// zooms to a region that encloses the annotations
// kind of a crude version
// (using CGRect for latitude/longitude regions is sorta weird, but CGRectUnion is nice to have!)

- (void)updateRegion
{
    self.needUpdateRegion = NO;
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (annotation.coordinate.latitude!=0 && annotation.coordinate.latitude!=0) {
            if (!started) {
                started = YES;
                boundingRect = annotationRect;
            } else {
                
                boundingRect = CGRectUnion(boundingRect, annotationRect);
            }
         }
    }
    if (started) {
        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
        //if ((boundingRect.size.width < 20) && (boundingRect.size.height < 20)) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width/2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height/2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        //}
    }
     
  
}

@end
