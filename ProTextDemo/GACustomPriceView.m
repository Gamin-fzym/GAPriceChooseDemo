//
//  GACustomPriceView.m
//  ProTextDemo
//
//  Created by Gamin on 2019/7/28.
//  Copyright © 2019 gamin.com. All rights reserved.
//

#import "GACustomPriceView.h"

//16进制颜色
#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

@interface GACustomPriceView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minLeftConstraint;  // min滑块left约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxRightConstraint; // max滑块right约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minWConstraint; // 滑块宽度
@property (weak, nonatomic) IBOutlet UILabel *priceLab;       // 价格区间lab
@property (weak, nonatomic) IBOutlet UILabel *minSliderLab;   // min滑块lab
@property (weak, nonatomic) IBOutlet UILabel *maxSliderLab;   // max滑块lab
@property (weak, nonatomic) IBOutlet UIView *defaultLineView; // 默认线段
@property (weak, nonatomic) IBOutlet UIView *selectLineView;  // 选择线段
@property (assign, nonatomic) float minStart; // 开始拖动时的minPrice
@property (assign, nonatomic) float maxStart; // 开始拖动时的maxPrice

@end

@implementation GACustomPriceView

- (void)drawRect:(CGRect)rect {
    [self initViewAction];
    // 默认 回调
    _minPrice = @"0";
    _maxPrice = @"100";
    if (self.priceBlock) {
        self.priceBlock(_minPrice, _maxPrice);
    }
}

// 初始化页面
- (void)initViewAction {
    UIColor *dColor = COLOR_WITH_HEX(0xcccccc);
    UIColor *sColor = COLOR_WITH_HEX(0xca9b63);
    _defaultLineView.backgroundColor = dColor;
    _selectLineView.backgroundColor = sColor;
    
    NSInteger count = 10;
    float w = _minWConstraint.constant;
    float total = [UIScreen mainScreen].bounds.size.width-2*15-w/2.0*2;
    float part_x = total / (float)(count);
    for (int i = 0 ; i < count+1 ; i ++) {
        UIView *defPart = [UIView new];
        defPart.backgroundColor = dColor;
        UIView *selPart = [UIView new];
        selPart.backgroundColor = sColor;
        CGRect tempRect;
        float dev = 0;
        if (i == 0) {
            tempRect = CGRectMake(0, 0, 2, 6);
            dev = 2/2.0;
        } else if (i == count) {
            tempRect = CGRectMake(0, 0, 2, 6);
            dev = -2/2.0;
        } else {
            tempRect = CGRectMake(0, 0, 4, 4);
            [defPart.layer setCornerRadius:2.0];
            [selPart.layer setCornerRadius:2.0];
        }
        defPart.bounds = tempRect;
        defPart.center = CGPointMake(part_x*i+dev, _defaultLineView.bounds.size.height/2.0);
        selPart.bounds = tempRect;
        selPart.center = CGPointMake(part_x*i+dev, _selectLineView.bounds.size.height/2.0);
        [_defaultLineView addSubview:defPart];
        [_selectLineView addSubview:selPart];
    }
}

// minPrice拖动
- (IBAction)panMinPriceView:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    UIGestureRecognizerState state = pan.state;
    if (state == UIGestureRecognizerStateBegan) {
        _minStart = _minLeftConstraint.constant;
    } else if (state == UIGestureRecognizerStateChanged) {
        CGPoint a = [pan translationInView:pan.view];
        float x = _minStart + a.x;
        if (x < 0) {
            x = 0;
        }
        if ([self judgeDistance] || (x>0 && a.x<0)) {
            _minLeftConstraint.constant = x;
        }
    }
    [self getSelectPrice];
}

// maxPrice拖动
- (IBAction)panMaxPriceView:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    UIGestureRecognizerState state = pan.state;
    if (state == UIGestureRecognizerStateBegan) {
        _maxStart = _maxRightConstraint.constant;
    } else if (state == UIGestureRecognizerStateChanged) {
        CGPoint a = [pan translationInView:pan.view];
        float x = _maxStart - a.x;
        if (x < 0) {
            x = 0;
        }
        if ([self judgeDistance] || (x>0 && a.x>0)) {
            _maxRightConstraint.constant = x;
        }
    }
    [self getSelectPrice];
}

// 两滑块是否达到最小间距
- (BOOL)judgeDistance {
    float w = _minWConstraint.constant;
    float l = _minLeftConstraint.constant;
    float r = _maxRightConstraint.constant;
    float distance = [UIScreen mainScreen].bounds.size.width-2*15-l-r;
    if (distance > 2*w) {
        return YES;
    }
    return NO;
}

// 选择的价格
- (void)getSelectPrice {
    float w = _minWConstraint.constant;
    float l = _minLeftConstraint.constant;
    float r = _maxRightConstraint.constant;
    float total = [UIScreen mainScreen].bounds.size.width-2*15-w/2.0*2;
    _minPrice = [NSString stringWithFormat:@"%d",(int)(100*(l/total))];
    _maxPrice = [NSString stringWithFormat:@"%d",(int)(100-100*(r/total))];
    
    NSString *tempPrice = @"";
    if ([_minPrice integerValue] == 0 && [_maxPrice integerValue] == 100) {
        tempPrice = @"不限";
        _maxSliderLab.text = @"不限";
    } else if ([_maxPrice integerValue] == 100) {
        tempPrice = [NSString stringWithFormat:@"%@-%@",_minPrice,@"不限"];
        _maxSliderLab.text = @"不限";
    } else {
        tempPrice = [NSString stringWithFormat:@"%@-%@",_minPrice,_maxPrice];
        _maxSliderLab.text = _maxPrice;
    }
    _priceLab.text = tempPrice;
    _minSliderLab.text = _minPrice;
    if (self.priceBlock) {
        self.priceBlock(_minPrice, _maxPrice);
    }
}

@end
