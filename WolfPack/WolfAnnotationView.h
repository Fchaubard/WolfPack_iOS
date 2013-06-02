//
//  WolfAnnotationView.h
//  WolfPack
//
//  Created by Francois Chaubard on 3/10/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIGestureRecognizer.h>
#import <QuartzCore/QuartzCore.h>
#import "Friend+MKAnnotation.h"
@interface WolfAnnotationView : MKAnnotationView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) Friend *friend;
@property (nonatomic, strong) UIPanGestureRecognizer *recognizer;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) int radius;
@property (nonatomic, strong) UIView *smallView;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, weak) MKMapView *mapView;

-(void)showSmallView;

- (id)initWithFrame:(CGRect)frame andAnnotation:(id<MKAnnotation>)thisAnnotation withReuseId:(NSString *)string;

@end
