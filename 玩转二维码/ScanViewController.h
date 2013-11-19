//
//  ScanViewController.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Decoder.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController : BaseViewController<DecoderDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
//@property (nonatomic, assign) id<CustomViewControllerDelegate> delegate;

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, assign) BOOL isScanning;
@end
