//
//  GACustomPriceView.h
//  ProTextDemo
//
//  Created by Gamin on 2019/7/28.
//  Copyright © 2019 gamin.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GACustomPriceView : UIView

@property (strong, nonatomic) NSString *minPrice; // 最小价格
@property (strong, nonatomic) NSString *maxPrice; // 最大价格

typedef void (^SelectPriceBlock)(NSString *minPrice, NSString *maxPrice);
@property (strong, nonatomic) SelectPriceBlock priceBlock;

@end

NS_ASSUME_NONNULL_END
