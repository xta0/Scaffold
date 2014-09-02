require './txqs_parser.rb'
require './txqs_mappings.rb'
require './txqs_util.rb'


g_path = ARGV[0]
g_author = ARGV[1]


def createViews(path,author)

  ##parse xibs
  parser = XibParser.new(path)
  result = parser.parse()
  
  result.each{|k,v|
  
    imports = []
    props   = []
    codes   = []
    sels    = []   
    clz = MAPPINGS::OBJC_CLASS[v["clz"]]
    bind_clz = v["data"].keys[0]
    bind_name = v["data"].values[0]
    
    if clz == "TBCitySBTableViewCell"
        imports.push("TBCitySBTableViewCell")
        imports.push(bind_clz) if(bind_clz)
    else
       imports.push(bind_clz) if(bind_clz)
       props.push("@property(nonatomic,strong)#{bind_clz} *#{bind_name}") if(bind_clz && bind_name)
    end

    
    #@class....
    #@property
    v["subviews"].each{|subv|
      imports.push(subv.customClz) if(subv.customClz)
      prop = "@property(nonatomic,strong)#{subv.clz}* #{subv.name}"
      props.push(prop)
      code,_sels =  subv.objc_code()
      codes.push(code)
      _sels.each{ |sel| sels.push(sel)}
    }
 
    
    #header
    if File.exist?("./#{k}.h")
      File.delete("./#{k}.h")
    end

    File.open("./#{k}.h","w"){|f|
      #注释
      str = commentsOfFile("h","#{k}",author)
      f.puts str
      
      #头文件
      str = headerFileContent(imports,"#{k}",clz,props,[],[])
      f.puts str
    }

    #body
    if File.exist?("./#{k}.m")
      File.delete("./#{k}.m")
    end

    File.open("./#{k}.m","w"){|f|
      
      f.puts "\n#import \"#{k}.h\" \n"
      str = ""
      imports.each{|i|
        str += "#import \"#{i}.h\"\n"
      }
      f.puts str
      str = "@interface #{k}() \n"
      str += "\n@end\n"
      str += "\n@implementation #{k}\n"
      f.puts str
      
      str = ""
      if clz == 'UIView'
        str = "\n- (id)initWithFrame:(CGRect)frame \n{"
        str += "\n  self = [super initWithFrame:frame]; \n\n  if (self) { \n"
      elsif clz == 'TBCitySBTableViewCell'
        str = "\n- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier \n{"
        str += "\n  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) { \n\n"
      end
      f.puts str
      
      #background color
      color = v["bkcolor"]
      f.puts "\n  self.backgroundColor = #{color}; \n" if(color)
        
      codes.each{|code| f.puts code}
  
      f.puts "\n  }\n"
      #end init-with-frame 
      f.puts "\n  return self; \n}"
      
      #set item
      if(bind_clz)
        5.times{f.puts "\n"}
        if(clz == "TBCitySBTableViewCell")
          f.puts "- (void)setItem:(#{bind_clz} *)item{\n      [super setItem:item];\n      //todo... \n\n}\n"
        else
          f.puts "- (void)setItem:(#{bind_clz} *)#{bind_name}{\n      _#{bind_name} = #{bind_name};\n     //todo... \n\n}\n"
        end
      end
      
    
      #add cells
      5.times{f.puts "\n"}
      f.puts "#pragma-marks - callback"
    
      sels.each{|sel| 
        f.puts "\n#{sel}  \n"
        3.times{f.puts "\n"}
      }
      f.puts "\n@end\n"  
    }
  }
  
end

if g_path & g_author
  createViews(g_path,g_author)
end
