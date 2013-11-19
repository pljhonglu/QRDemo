//
//  MainViewController.h
//  玩转二维码
//
//  Created by pljhonglu on 13-11-11.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BaseViewController.h"

@interface MainViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,ABPeoplePickerNavigationControllerDelegate>

@end
