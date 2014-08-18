#created by jayson.xu

module MAPPINGS

  #xib's class type <=> objc
  OBJC_CLASS = {"view" => "UIView", 
               "label" => "UILabel",
               "button" => "UIButton", 
               "imageView" => "UIImageView",
               "tableViewCell" => "UITableViewCell"} 
  
  #xib's button type <=> objc
  OBJC_BTN_TYPE = {"contactAdd" => "UIButtonTypeContactAdd",
                      "roundedRect" => "UIButtonTypeRoundedRect"}
  
  #xib's lable's linebreakmode <=> objc
  OBJC_LINEBREAK_MODE = {"tailTruncation" => "NSLineBreakByTruncatingTail"}
  
  #xib's lable's textalignment <=>
  OBJC_TEXT_ALIGNMENT = {"center" => "NSTextAlignmentCenter",
                         "left" => "NSTextAlignmentLeft", 
                         "right" => "NSTextAlignmentRight"}
  

  #COLOR
  def MAPPINGS.colorWithRGBA(r,g,b,a)
    return "[UIColor colorWithRed:#{r} green:#{g} blue:#{b} alpha:#{a}]"
  end
    
  

end