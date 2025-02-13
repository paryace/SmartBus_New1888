//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// container

#import "Bee_UIBoard.h"
#import "Bee_UIRouter.h"
#import "Bee_UIStack.h"

#import "BeeUIBoard+BackwardCompatible.h"
#import "BeeUIBoard+ModalBoard.h"
#import "BeeUIBoard+ModalStack.h"
#import "BeeUIBoard+ModalView.h"
#import "BeeUIBoard+Popover.h"
#import "BeeUIBoard+Traversing.h"

#import "UIView+UINavigationController.h"
#import "UIView+UIViewController.h"
#import "UIViewController+LifeCycle.h"
#import "UIViewController+Metrics.h"
#import "UIViewController+Title.h"
#import "UIViewController+Traversing.h"
#import "UIViewController+UINavigationBar.h"
#import "UIViewController+UINavigationController.h"

// dom-animation

#import "Bee_UIAnimation.h"
#import "Bee_UIAnimationAlpha.h"
#import "Bee_UIAnimationBounce.h"
#import "Bee_UIAnimationZoom.h"

#import "UIView+Animation.h"
#import "UIView+Transition.h"
#import "UIViewController+Transition.h"

// dom-binding

#import "Bee_UIDataBinding.h"
#import "UIButton+UIDataBinding.h"
#import "UIImageView+UIDataBinding.h"
#import "UILabel+UIDataBinding.h"
#import "UITextField+UIDataBinding.h"
#import "UITextView+UIDataBinding.h"

// dom-element

#import "Bee_UIAccelerometer.h"
#import "Bee_UIActionSheet.h"
#import "Bee_UIActivity.h"
#import "Bee_UIActivityIndicatorView.h"
#import "Bee_UIAlertView.h"
#import "Bee_UIButton.h"
#import "Bee_UIDatePicker.h"
#import "Bee_UIImagePickerController.h"
#import "Bee_UIImageView.h"
#import "Bee_UIKeyboard.h"
#import "Bee_UILabel.h"
#import "Bee_UIMenuController.h"
#import "Bee_UINavigationBar.h"
#import "Bee_UIPageControl.h"
#import "Bee_UIPageViewController.h"
#import "Bee_UIPickerView.h"
#import "Bee_UIProgressView.h"
#import "Bee_UIScrollView.h"
#import "Bee_UISearchBar.h"
#import "Bee_UISegmentedControl.h"
#import "Bee_UISlider.h"
#import "Bee_UISwitch.h"
#import "Bee_UITabBar.h"
#import "Bee_UITableView.h"
#import "Bee_UITableViewCell.h"
#import "Bee_UITextField.h"
#import "Bee_UITextView.h"
#import "Bee_UIToolbar.h"
#import "Bee_UIVideoEditorController.h"
#import "Bee_UIView.h"
#import "Bee_UIWebView.h"

#import "UIView+Background.h"
#import "UIView+LifeCycle.h"
#import "UIView+Manipulation.h"
#import "UIView+Metrics.h"
#import "UIView+HoldGesture.h"
#import "UIView+PanGesture.h"
#import "UIView+SwipeGesture.h"
#import "UIView+Tag.h"
#import "UIView+TapGesture.h"
#import "UIView+Traversing.h"
#import "UIView+Visibility.h"
#import "UIView+Wireframe.h"

// dom-element-ext

#import "Bee_UICameraView.h"
#import "Bee_UIMatrixView.h"
#import "Bee_UIPullLoader.h"
#import "Bee_UITipsView.h"
#import "Bee_UIZoomView.h"

// comment

#import "Bee_UIMetrics.h"

// dom-event

#import "Bee_UISignal.h"
#import "Bee_UISignalBus.h"
#import "UIView+BeeUISignal.h"
#import "UIViewController+BeeUISignal.h"
#import "BeeUISignal+SourceView.h"

// theme

#import "UIColor+Theme.h"
#import "UIFont+Theme.h"
#import "UIImage+Theme.h"

// backward compatible

#import "UINavigationBar+BeeExtension.h"
#import "UIView+BeeExtension.h"

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
