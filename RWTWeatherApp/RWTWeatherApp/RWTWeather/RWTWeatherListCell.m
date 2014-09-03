
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
   self.icon =[[UIImageView alloc]initWithFrame:CGRectMake(5.0,5.0,80.0,80.0)];
   [self addSubview:self.icon];

   //DateLabel
   self.DateLabel =[[UILabel alloc]initWithFrame:CGRectMake(110.0,5.0,190.0,20.0)];
   self.DateLabel.font = [UIFont systemFontOfSize:16];
   self.DateLabel.textColor = [UIColor colorWithRed:0.20000000298023224 green:0.20000000298023224 blue:0.20000000298023224 alpha:1];
   self.DateLabel.text = @"date";
   self.DateLabel.textAlignment = NSTextAlignmentLeft;
   self.DateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   [self addSubview:self.DateLabel];

   //statusLabel
   self.statusLabel =[[UILabel alloc]initWithFrame:CGRectMake(110.0,34.0,190.0,14.0)];
   self.statusLabel.font = [UIFont systemFontOfSize:14];
   self.statusLabel.textColor = [UIColor colorWithRed:1 green:0.0 blue:0.0 alpha:1];
   self.statusLabel.text = @"status";
   self.statusLabel.textAlignment = NSTextAlignmentLeft;
   self.statusLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   [self addSubview:self.statusLabel];

  }

  return self; 
}





- (void)setItem:(RWTWeatherListItem *)item{
      [super setItem:item];
      //todo...
    self.DateLabel.text = item.date;
    self.statusLabel.text = item.weatherDesc[0][@"value"];
    [self.icon setImageWithURL:[NSURL URLWithString:item.weatherIconUrl[0][@"value"]]];

}





#pragma-marks - callback

@end
