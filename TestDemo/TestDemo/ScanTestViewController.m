//
//  ScanTestViewController.m
//  TestDemo
//
//  Created by gaochongyang on 2019/10/12.
//  Copyright © 2019 gaochongyang. All rights reserved.
//

#import "ScanTestViewController.h"
#import <TBScanSDK/TBScanSDK.h>

@interface ScanTestViewController ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL viewHadAppear;
@property (nonatomic, assign) BOOL cameraHadResume;

@end

@implementation ScanTestViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.delegate = self;
        CGRect rect = [ScanTestViewController constructScanAnimationRect];
        int extend = CGRectGetWidth(self.view.frame) / 320 * 10;
        CGFloat offset = (CGRectGetWidth(self.view.frame) + extend * 2 - CGRectGetWidth(rect)) / 2;
        self.rectOfInterest = CGRectMake(rect.origin.x - offset,
                                         rect.origin.y - offset,
                                         CGRectGetWidth(rect) + 2 * offset,
                                         CGRectGetHeight(rect) + 2 * offset);
        self.cameraWidthPercent = 0.67;
        self.scanType = ScanType_QRCode | ScanType_Barcode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"photo" style:UIBarButtonItemStylePlain target:self action:@selector(selectPhoto)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.maskView];
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.backgroundColor = [UIColor redColor];
    self.indicatorView.center = self.maskView.center;
    [self.maskView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewHadAppear = YES;
    [self checkAnimation];
}

#pragma mark Action
- (void)selectPhoto
{
    [self scanPhotoLibrary];
}

- (void)resumeScan
{
    [super resumeScan];
    self.cameraHadResume = YES;
    [self checkAnimation];
}

- (void)checkAnimation
{
    if (self.viewHadAppear && self.cameraHadResume)
    {
        [self.indicatorView removeFromSuperview];
        [self.indicatorView stopAnimating];
        self.indicatorView = nil;
        
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }
}

#pragma mark TBScanViewControllerDelegate

-(void)didFind:(NSArray<TBScanResult*>*)resultArray
{
    TBScanResult *result = resultArray.firstObject;
    NSString* content = result.data;
    if (result.resultType == TBScanResultTypeQRCode) {
        content = [NSString stringWithFormat:@"qrcode:%@, hiddenData:%@, TBScanQRCodeResultType:%@", result.data, result.hiddenData, [result.extData objectForKey:TBScanResultTypeQRCode]];
        NSLog(@"subType is %@, ScanType_QRCode is %@", @(result.subType), @(ScanType_QRCode));
    } else if (result.resultType == TBScanResultTypeVLGen3Code) {
        content = [NSString stringWithFormat:@"gen3:%@", result.data];
        NSLog(@"subType is %@, ScanType_GEN3 is %@", @(result.subType), @(ScanType_GEN3));
    } else if (result.resultType == TBScanResultTypeGoodsBarcode) {
        content = [NSString stringWithFormat:@"barcode:%@", result.data];
        NSLog(@"subType is %@, EAN13 is %@", @(result.subType), @(EAN13));
    } else if (result.resultType == TBScanResultTypeDataMatrixCode) {
        content = [NSString stringWithFormat:@"dm:%@", result.data];
        NSLog(@"subType is %@, ScanType_DATAMATRIX is %@", @(result.subType), @(ScanType_DATAMATRIX));
    } else if (result.resultType == TBScanResultTypeExpressCode) {
        content = [NSString stringWithFormat:@"express:%@", result.data];
        NSLog(@"subType is %@, ScanType_FASTMAIL is %@", @(result.subType), @(ScanType_FASTMAIL));
    } else if (result.resultType == TBScanResultTypeTB4GCode) {
        content = [NSString stringWithFormat:@"4g:%@, bitstream length:%lu", result.data, (unsigned long)[[result.extData objectForKey:TBScanResultTypeTB4GCode] length]];
        NSLog(@"subType is %@, ScanType_4G is %@", @(result.subType), @(ScanType_4G));
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 9999;
        [alert show];
    });
    
    for (NSInteger i = 0; i < 100; i++) {
        [APRemoteLogger writeLogWithActionId:KActionID_Event extParams:nil appId:@"tttttttt" seed:nil ucId:nil];
    }
}

- (void)cameraPermissionDenied
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cameraDidStart
{
    NSLog(@"started!!");
}

-(void)setTorchState:(TorchState)bState
{
    NSLog(@"TorchState:%i", bState);
}

-(void)setImagePickerNavigationBarStyle:(UINavigationBar *)navigationBar
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        navigationBar.barStyle = UIBarStyleBlack;
        navigationBar.translucent = YES;
        navigationBar.barTintColor = [UIColor colorWithRed:20.f/255.0 green:24.0/255.0 blue:38.0/255.0 alpha:1];
        navigationBar.tintColor = [UIColor whiteColor];
    }
}

-(void)userTrack:(NSString*)name
{
    NSLog(@"userTrack:%@", name);
}

-(void)userTrack:(NSString*)name args:(NSDictionary*)data
{
    NSLog(@"userTrack:%@, args:%@", name, data);
}

-(void)buildContainerView:(UIView*)containerView
{
    UIView* bg = [[UIView alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:bg];
    CGRect rect = [ScanTestViewController constructScanAnimationRect];
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor orangeColor];
    view.alpha = 0.3;
    [bg addSubview:view];
}

+ (CGRect)constructScanAnimationRect
{
    CGSize screenXY = [UIScreen mainScreen].bounds.size;
    NSInteger focusFrameWH = screenXY.width / 320 * 220;//as wx
    int offet = 10;
    if (screenXY.height == 568)
        offet = 19;
    
    return CGRectMake((screenXY.width - focusFrameWH) / 2,
                      (screenXY.height - 64 - focusFrameWH - 83 - 50 - offet) / 2 + 64,
                      focusFrameWH,
                      focusFrameWH);
}

#pragma mark alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:TBScanContinueNotification object:nil];
}


@end

