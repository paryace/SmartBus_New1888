//
//  BHUserCheckBoard.m
//  SmartBus
//
//  Created by launching on 13-11-7.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHUserCheckBoard.h"
#import "DatePickerSheet.h"
#import "TSLocateView.h"

@interface BHUserCheckBoard ()<UITableViewDataSource, UITableViewDelegate, UIPickerSheetDelegate>
{
    CheckMode checkMode;
    NSInteger selectedItemIdex;
}
- (void)createViewsAccordingCheckMode:(CheckMode)mode;
- (void)addInputBar:(NSString *)placeholder content:(NSString *)content;
- (void)addInputView;
- (void)addCheckTable;
- (void)addPickerControl;
@end

#define kSubViewTag         1912

@implementation BHUserCheckBoard

DEF_SIGNAL( DONE_MODIFY );

- (id)initWithCheckMode:(CheckMode)mode
{
    if ( self = [super init] )
    {
        checkMode = mode;
    }
    return self;
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        if (self.registered) {
            [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_profile.png"] title:@"注册"];
        } else {
            [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_setting.png"] title:@"个人资料"];
        }
        
        BeeUIButton *menu = [BeeUIButton new];
        menu.frame = CGRectMake(280.f, 2.f, 40.f, 40.f);
        menu.image = [UIImage imageNamed:@"icon_certain.png"];
        [menu addSignal:self.DONE_MODIFY forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:menu];
        
        [self createViewsAccordingCheckMode:checkMode];
	}
    if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        if ( checkMode == CheckModeGender )
        {
            selectedItemIdex = [BHUserModel sharedInstance].ugender;
        }
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.DONE_MODIFY] )
    {
        if ( checkMode == CheckModeUserName )
        {
            UITextField *textField = (UITextField *)[self.beeView viewWithTag:kSubViewTag];
            [BHUserModel sharedInstance].uname = textField.text;
        }
        else if ( checkMode == CheckModeProfession )
        {
            UITextField *textField = (UITextField *)[self.beeView viewWithTag:kSubViewTag];
            [BHUserModel sharedInstance].profession = textField.text;
        }
        else if ( checkMode == CheckModeSignature )
        {
            UITextView *textView = (UITextView *)[self.beeView viewWithTag:kSubViewTag];
            [BHUserModel sharedInstance].signature = textView.text;
        }
        [self.stack popBoardAnimated:YES];
    }
}

- (void)createViewsAccordingCheckMode:(CheckMode)mode
{
    if ( mode == CheckModeUserName || mode == CheckModeProfession )
    {
        NSString *placeholder = mode == CheckModeUserName ? @"输入您的昵称" : @"输入您的职业";
        NSString *value = mode == CheckModeUserName ? [BHUserModel sharedInstance].uname : [BHUserModel sharedInstance].profession;
        [self addInputBar:placeholder content:value];
    }
    else if ( mode == CheckModeAddress || mode == CheckModeBirthday )
    {
        [self addPickerControl];
    }
    else if ( mode == CheckModeGender )
    {
        [self addCheckTable];
    }
    else if ( mode == CheckModeSignature )
    {
        [self addInputView];
    }
}


#pragma mark -
#pragma mark private methods

- (void)addInputBar:(NSString *)placeholder content:(NSString *)content
{
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
    bubbleImageView.frame = CGRectMake(10.f, 12.f, 300.f, 48.f);
    [self.beeView addSubview:bubbleImageView];
    [bubbleImageView release];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25.f, 16.f, 270.f, 40.f)];
    textField.backgroundColor = [UIColor clearColor];
    textField.tag = kSubViewTag;
    textField.font = FONT_SIZE(14);
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = placeholder;
    textField.text = content;
    [self.beeView addSubview:textField];
    [textField release];
}

- (void)addInputView
{
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
    bubbleImageView.frame = CGRectMake(10.f, 12.f, 300.f, 100.f);
    [self.beeView addSubview:bubbleImageView];
    [bubbleImageView release];
    
    BeeUITextView *textView = [[BeeUITextView alloc] initWithFrame:CGRectMake(15.f, 17.f, 290.f, 90.f)];
    textView.backgroundColor = [UIColor clearColor];
    textView.tag = kSubViewTag;
    textView.font = FONT_SIZE(14);
    textView.placeholder = @"输入您个人简介";
    textView.text = [BHUserModel sharedInstance].signature;
    [self.beeView addSubview:textView];
    [textView release];
}

- (void)addCheckTable
{
    BeeUITableView *tableView = [[BeeUITableView alloc] initWithFrame:self.beeView.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = [UIView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    [self.beeView addSubview:tableView];
    [tableView release];
}

- (void)addPickerControl
{
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
    bubbleImageView.frame = CGRectMake(10.f, 12.f, 300.f, 48.f);
    [self.beeView addSubview:bubbleImageView];
    [bubbleImageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 16.f, 70.f, 40.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(14);
    label.text = checkMode == CheckModeAddress ? @"地区" : @"出生日期";
    [self.beeView addSubview:label];
    [label release];
    
    NSString *title = nil;
    if ( checkMode == CheckModeAddress ) {
        title = [BHUserModel sharedInstance].location ? [BHUserModel sharedInstance].location : @"点击选择地区";
    } else if ( checkMode == CheckModeBirthday ) {
        title = [BHUserModel sharedInstance].birth ? [BHUserModel sharedInstance].birth : @"点击选择生日";
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100.f, 16.f, 180.f, 40.f);
    button.tag = kSubViewTag;
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = FONT_SIZE(14);
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:button];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableIdentifier";
    
    BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];;
    if ( !cell )
    {
        cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
    }
    
    NSString *text = nil;
    if ( indexPath.row == 0 ) {
        text = @"保密";
    } else if ( indexPath.row == 1 ) {
        text = @"男";
    } else {
        text = @"女";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"    %@", text];
    cell.textLabel.font = FONT_SIZE(14);
    
    if ( indexPath.row == selectedItemIdex ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectedItemIdex == indexPath.row) {
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    UITableViewCell *lastTableCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedItemIdex inSection:0]];
    [lastTableCell setAccessoryType:UITableViewCellAccessoryNone];
    
    selectedItemIdex = indexPath.row;
    [BHUserModel sharedInstance].ugender = indexPath.row;
}


#pragma mark -
#pragma mark UIPickerSheetDelegate

- (void)pickerSheet:(UIView *)sheet selectWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) return;
    
    if ( [sheet isKindOfClass:[TSLocateView class]] )
    {
        TSLocateView *locateView = (TSLocateView *)sheet;
        [BHUserModel sharedInstance].location = [NSString stringWithFormat:@"%@-%@市", locateView.locate.state, locateView.locate.city];
        UIButton *button = (UIButton *)[self.beeView viewWithTag:kSubViewTag];
        [button setTitle:[BHUserModel sharedInstance].location forState:UIControlStateNormal];
    }
    else
    {
        DatePickerSheet *datePicker = (DatePickerSheet *)sheet;
        [BHUserModel sharedInstance].birth = [datePicker dateString];
        
        UIButton *button = (UIButton *)[self.beeView viewWithTag:kSubViewTag];
        [button setTitle:[BHUserModel sharedInstance].birth forState:UIControlStateNormal];
    }
}


#pragma mark -
#pragma mark button events

- (void)buttonAction:(UIButton *)sender
{
    if ( checkMode == CheckModeAddress )
    {
        TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"地区选择" delegate:self];
        [locateView showInView:self.view];
        [locateView release];
    }
    else
    {
        DatePickerSheet *datePicker = [[DatePickerSheet alloc] initWithTitle:@"生日选择" delegate:self];
        [datePicker showInView:self.view];
        [datePicker setDateString:@"1900-01-01" animated:YES];
        [datePicker release];
    }
}

@end
