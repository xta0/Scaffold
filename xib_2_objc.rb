#created by jayson.xu

module XIB2OBJC

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
  

  #COLOR
  def colorWithRGBA(r,g,b,a)
    return "[UIColor colorWithRed:#{r} green:#{g} blue:#{b} alpha:#{a}]"
  end
    
  

end