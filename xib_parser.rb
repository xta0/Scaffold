#
#created by jayson.xu
#
require 'nokogiri'
require './uikit_2_ruby.rb'
require './xib_2_objc.rb'


objc_clzz = {"label" => "UILabel", "button" => "UIButton", "imageView" => "UIImageView"} 

f = File.open("./xib.xml")
doc = Nokogiri::XML(f)
f.close

##

#get root view
root_view = doc.at_xpath('//view')
root_view_name = root_view["customClass"]

#get subviews
subview_names = Array.new()
subview_class = Array.new()
subview_objcs = Array.new()

subviews = root_view.xpath("subviews/*") ## subviews => Nokogiri::XML::NodeSet

#get subviews class
subviews.each do |v| ## v => Nokogiri::XML::Element
  
  #clz
  objc_clz = objc_clzz[v.name]
  subview_class << objc_clz
  
  #name
  objc_name = v.at_xpath('accessibility')["label"]
  subview_names << objc_name
  
  #objc
  objc_obj = UIKitFactory.UIKitObj(v,objc_name)
  subview_objcs << objc_obj
  
end



##create file
#def create_h()
  
  if File.exist?("./#{root_view_name}.h")
    File.delete("./#{root_view_name}.h")
  end

  f = File.open("./#{root_view_name}.h","w") do |f|
  
    f.puts "\ncreated by xib_2_objC \n\n"
    f.puts "#import <UIKit/UIkit.h> \n\n"
    f.puts "@interface #{root_view_name} : UIView \n"
    f.puts "\n"
  
    counter = 0 
    subview_class.each do |clz|
      f.puts"@property(nonatomic,strong)#{clz}* #{subview_names[counter]};\n"
      counter = counter+1
    end

    f.puts "\n@end"

  end
  
  #end

#def create_m()
  
  if File.exist?("./#{root_view_name}.m")
    File.delete("./#{root_view_name}.m")
  end
  
  puts "#{root_view_name}"
  
  f = File.open("./#{root_view_name}.m","w") do |f|
  
    f.puts "\n#import \"#{root_view_name}.h\" \n"
    f.puts "\n@interface #{root_view_name}()\n"
    f.puts "\n@end\n"
  
    f.puts "\n@implementation #{root_view_name}\n"
    
    #begin init-with-frame
    f.puts "\n- (id)initWithFrame:(CGRect)frame \n{"
    
    f.puts "\n  self = [super initWithFrame:frame]; \n\n  if (self) { \n"
    
    selectors = Array.new
    #add subviews here
    subview_objcs.each do |obj|
      str,sels =  obj.objc_code()
      f.puts str
      
      sels.each{ |sel| selectors << sel }
    end
    
  
    f.puts "\n  }\n"
    
    #end init-with-frame
    f.puts "\n  return self; \n}"
    
    #add sels
    5.times{f.puts "\n"}
    f.puts "#pragma-marks - callback"
    
    selectors.each do |sel|
      
      f.puts "\n#{sel}  \n"
      3.times{f.puts "\n"}
      
    end
  
  
    f.puts "\n@end\n"

  end




