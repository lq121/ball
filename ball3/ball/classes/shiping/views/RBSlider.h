#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RBSlider;
typedef void (^SliderValueChangeBlock) (RBSlider *slider);
typedef void (^SliderFinishChangeBlock) (RBSlider *slider);
typedef void (^DraggingSliderBlock) (RBSlider *slider);

@interface RBSlider : UIView

@property (nonatomic, assign) CGFloat value;        /* From 0 to 1 */
@property (nonatomic, assign) CGFloat middleValue;  /* From 0 to 1 */

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat sliderDiameter;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *minColor;

@property (nonatomic, copy) SliderValueChangeBlock valueChangeBlock;
@property (nonatomic, copy) SliderFinishChangeBlock finishChangeBlock;
@property (nonatomic, strong) DraggingSliderBlock draggingSliderBlock;
@end

NS_ASSUME_NONNULL_END
