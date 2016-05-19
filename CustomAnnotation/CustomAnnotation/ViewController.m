//
//  ViewController.m
//  CustomAnnotation
//
//  Created by  江苏 on 16/5/19.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import "JSAnnotation.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

/*地理编码*/
@property(strong,nonatomic)CLGeocoder* geoCoder;

@end

@implementation ViewController

#pragma mark--懒加载
/*地理编码*/
-(CLGeocoder *)geoCoder
{
    if (_geoCoder==nil) {
        _geoCoder=[[CLGeocoder alloc]init];
    }
    return _geoCoder;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point=[[touches anyObject] locationInView:self.mapView];
    
    CLLocationCoordinate2D coor=[self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    [self addAnnotationWithCoordinate2D:coor];
}

-(void)addAnnotationWithCoordinate2D:(CLLocationCoordinate2D)coor{
    
    CLLocation* location=[[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude];
    
    JSAnnotation* annoModel=[[JSAnnotation alloc]init];
    
    annoModel.coordinate=CLLocationCoordinate2DMake(coor.latitude,coor.longitude);
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark* placemark=[placemarks firstObject];
        
        annoModel.title=placemark.locality;
        
        annoModel.subtitle=placemark.name;
        
    }];
    
     [self.mapView addAnnotation:annoModel];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString* ID=@"indentifier";
    
    MKAnnotationView* annoV=[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (annoV==nil) {
        annoV=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
    }
    
    //MKAnnotationView
    annoV.annotation=annotation;
    
    annoV.image=[UIImage imageNamed:@"category_5"];
    
    annoV.canShowCallout=YES;
    
    UIImageView* LeftImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    LeftImageV.image=[UIImage imageNamed:@"placeHolder"];
    annoV.leftCalloutAccessoryView=LeftImageV;
    
    UIImageView* rightImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightImageV.image=[UIImage imageNamed:@"placeHolder"];
    annoV.leftCalloutAccessoryView=rightImageV;
    
    return annoV;
}

/*  选中一个大头针调用
*
*  @param mapView 地图
*  @param view    大头针视图
*/
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"选中---%@", view.annotation.title);
}


/**
 *  取消选中一个大头针调用
 *
 *  @param mapView 地图
 *  @param view    大头针视图
 */
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"取消选中---%@", view.annotation.title);
}
@end
