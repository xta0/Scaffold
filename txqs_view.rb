require './txqs_parser.rb'
require './txqs_mappings.rb'

puts "============================= \n"
puts "====根据xib创建view=========== \n"
puts "============================= \n"

def createViewHeaderFile(dict)
    
  dict.each do |k,v|
  
    #header
    if File.exist?("./#{k}.h")
      File.delete("./#{k}.h")
    end

    f = File.open("./#{k}.h","w") do |f|
  
      f.puts "\n// created by xib_2_objC \n"
      f.puts "\n// #{Time.new.inspect}\n\n"
      f.puts "#import <UIKit/UIkit.h> \n\n"
      
      v["subviews"].each do |uikit_obj|
        if uikit_obj.customClz
          f.puts "@class #{uikit_obj.clz};\n"
        end
      end
      
      parentClz = MAPPINGS::OBJC_CLASS[v["clz"]]
      
      f.puts "@interface #{k} : #{parentClz} \n"
      f.puts "\n"
  
      counter = 0 
      v["subviews"].each do |uikit_obj|
        f.puts"@property(nonatomic,strong)#{uikit_obj.clz}* #{uikit_obj.name};\n"
        counter = counter+1
      end
      
      f.puts "\n@end"

    end
  end
end

def createViewBodyFile(dict)
  
  dict.each do |k,v|
  
    if File.exist?("./#{k}.m")
      File.delete("./#{k}.m")
    end

    f = File.open("./#{k}.m","w") do |f|
  
      f.puts "\n#import \"#{k}.h\" \n"
      
      v["subviews"].each do |obj|
        if obj.customClz
          f.puts "#import \"#{obj.clz}.h\"\n"
        end
      end
      
      f.puts "\n@interface #{k}()\n"
      f.puts "\n@end\n"
  
      f.puts "\n@implementation #{k}\n"
    
      #begin init-with-frame
      parentClz = MAPPINGS::OBJC_CLASS[v["clz"]]
      if parentClz == 'UIView'
        f.puts "\n- (id)initWithFrame:(CGRect)frame \n{"
        f.puts "\n  self = [super initWithFrame:frame]; \n\n  if (self) { \n"
      elsif parentClz == 'UITableViewCell'
        f.puts "\n- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier \n{"
        f.puts "\n  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) { \n\n"
      end
      
      #background color
      color = v["bkcolor"]
      
      if(color)
        f.puts "\n  self.backgroundColor = #{color}; \n"
      end
    
      selectors = Array.new
      #add subviews here
      v["subviews"].each do |obj|
        str,sels =  obj.objc_code()
        f.puts str
        sels.each{ |sel| selectors << sel }
      end
    
  
      f.puts "\n  }\n"
      #end init-with-frame 
      f.puts "\n  return self; \n}"
    
      #add cells
      5.times{f.puts "\n"}
      f.puts "#pragma-marks - callback"
    
      selectors.each do |sel|
      
        f.puts "\n#{sel}  \n"
        3.times{f.puts "\n"}
      
      end
  
  
      f.puts "\n@end\n"  
  
  end
end
end



##parse xibs
parser = XibParser.new('./xib.xml')
v_hash = parser.parse()

##create views
createViewHeaderFile(v_hash)
createViewBodyFile(v_hash)


puts "============================= \n"
puts "===========Success=========== \n"
puts "============================= \n"