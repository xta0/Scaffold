
#import "RWTWeatherListCell.h" 
#import "TBCitySBTableViewCell.h"
#import "RWTWeatherListItem.h"
@interface RWTWeatherListCell() 

@end

@implementation RWTWeatherListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) { 


   //icon
   self.icon =[[UIImageView alloc]initWithFrame:CGRectMake(6.0,5.0,50.0,50.0)];
   [self addSubview:self.icon];

   //dateLabel
   self.dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(74.0,5.0,90,16.0)];
   self.dateLabel.font = [UIFont systemFontOfSize:16];
   self.dateLabel.textColor = [UIColor darkTextColor];
   self.dateLabel.text = @"date";
   self.dateLabel.textAlignment = NSTextAlignmentLeft;
   self.dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   [self addSubview:self.dateLabel];

   //minLabel
   self.minLabel =[[UILabel alloc]initWithFrame:CGRectMake(74.0,34.0,35.0,14.0)];
   self.minLabel.font = [UIFont systemFontOfSize:14];
   self.minLabel.textColor = [UIColor colorWithRed:0.20000000298023224 green:0.20000000298023224 blue:0.20000000298023224 alpha:1];
   self.minLabel.text = @"min";
   self.minLabel.textAlignment = NSTextAlignmentLeft;
   self.minLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   [self addSubview:self.minLabel];

   //toLabel
   self.toLabel =[[UILabel alloc]initWithFrame:CGRectMake(101.0,34.0,35.0,14.0)];
   self.toLabel.font = [UIFont systemFontOfSize:14];
   self.toLabel.textColor = [UIColor colorWithRed:0.20000000298023224 green:0.20000000298023224 blue:0.20000000298023224 alpha:1];
   self.toLabel.text = @"to";
   self.toLabel.textAlignment = NSTextAlignmentCenter;
   self.toLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   [self addSubview:self.toLabel];

   //maxLabel
   self.maxLabel =[[UILabel alloc]initWithFrame:CGRectMake(144.0,34.0,60.0,14.0)];
   self.maxLabel.font = [UIFont systemFontOfSize:14];
   self.maxLabel.textColor = [UIColor colorWithRed:0.20000000298023224 green:0.20000000298023224 blue:0.20000000298023224 alpha:1];
   self.maxLabel.text = @"max";
   self.maxLabel.textAlignment = NSTextAlignmentLeft;
   self.maxLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   [self addSubview:self.maxLabel];

   //stateLabel
   self.stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(160,5.0,150,14.0)];
   self.stateLabel.font = [UIFont systemFontOfSize:12];
   self.stateLabel.textColor = [UIColor colorWithRed:1 green:0.0 blue:0.0 alpha:1];
   self.stateLabel.text = @"state";
   self.stateLabel.textAlignment = NSTextAlignmentRight;
   self.stateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   [self addSubview:self.stateLabel];

  }

  return self; 
}





- (void)setItem:(RWTWeatherListItem *)item{
      [super setItem:item];
      //todo...
    self.dateLabel.text = item.date;
    self.maxLabel.text = item.tempMaxC;
    self.minLabel.text = item.tempMinC;
    self.stateLabel.text = item.weatherDesc[0][@"value"];
    [self.icon setImageWithURL:[NSURL URLWithString:item.weatherIconUrl[0][@"value"]]];

}





#pragma-marks - callback

@end
