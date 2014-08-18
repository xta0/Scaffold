require './txqs_parser.rb'

puts "============================= \n"
puts "====根据xib创建view=========== \n"
puts "============================= \n"

def createViewHeaderFile(dict,parentClz)
    
  dict.each do |k,v|
  
    #header
    if File.exist?("./#{k}.h")
      File.delete("./#{k}.h")
    end

    f = File.open("./#{k}.h","w") do |f|
  
      f.puts "\n// created by xib_2_objC \n\n"
      f.puts "#import <UIKit/UIkit.h> \n\n"
      f.puts "@interface #{k} : #{parentClz} \n"
      f.puts "\n"
  
      counter = 0 
      v.each do |uikit_obj|
        f.puts"@property(nonatomic,strong)#{uikit_obj.clz}* #{uikit_obj.name};\n"
        counter = counter+1
      end
      
      f.puts "\n@end"

    end
  end
end

def createViewBodyFile(dict,parentClz)
  
  dict.each do |k,v|
  
    if File.exist?("./#{k}.m")
      File.delete("./#{k}.m")
    end

    f = File.open("./#{k}.m","w") do |f|
  
      f.puts "\n#import \"#{k}.h\" \n"
      f.puts "\n@interface #{k}()\n"
      f.puts "\n@end\n"
  
      f.puts "\n@implementation #{k}\n"
    
      #begin init-with-frame
      if parentClz == 'UIView'
        f.puts "\n- (id)initWithFrame:(CGRect)frame \n{"
        f.puts "\n  self = [super initWithFrame:frame]; \n\n  if (self) { \n"
      elsif parentClz == 'UITableViewCell'
        f.puts "\n- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier \n{"
        f.puts "\n  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) { \n\n"
      end
    
      selectors = Array.new
      #add subviews here
      v.each do |obj|
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
parser.parse()

v_hash = parser.view_hash
c_hash = parser.cell_hash

##create views
createViewHeaderFile(v_hash,'UIView')
createViewBodyFile(v_hash,'UIView')
createViewHeaderFile(c_hash,'UITableViewCell')
createViewBodyFile(c_hash,'UITableViewCell')



puts "============================= \n"
puts "===========Success=========== \n"
puts "============================= \n"