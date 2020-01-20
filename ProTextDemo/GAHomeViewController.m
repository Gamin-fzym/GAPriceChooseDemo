//
//  GAHomeViewController.m
//  ProTextDemo
//
//  Created by Gamin on 2019/7/28.
//  Copyright © 2019 gamin.com. All rights reserved.
//

#import "GAHomeViewController.h"
#import "GACustomPriceView.h"
#import "Masonry/Masonry.h"

@interface GAHomeViewController ()

@property (strong, nonatomic) GACustomPriceView *cPriceView;

@end

@implementation GAHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    if (!_cPriceView) {
        _cPriceView = [[[NSBundle mainBundle] loadNibNamed:@"GACustomPriceView" owner:self options:nil] firstObject];
        [_cPriceView setPriceBlock:^(NSString * _Nonnull minPrice, NSString * _Nonnull maxPrice) {
            NSLog(@"min=%@,max=%@",minPrice,maxPrice);
        }];
    }
    [self.view addSubview:_cPriceView];
    [_cPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
}

@end
