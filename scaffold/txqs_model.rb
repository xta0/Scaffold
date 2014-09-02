require "json"
require "pp"
require "./txqs_util.rb"


def createModels(name,clz,api,v,ins,outs,author)

  prop_ins = []
  prop_outs = []

  ins.each{ |i|

    str = "@property(nonatomic,strong)NSString* #{i}"
    prop_ins.push(str)

  }
  
  outs.each{|o|
     o.each{|k,v|
      prop_outs.push("@property(nonatomic,strong,readonly)#{v} *#{k}")
    }
  }


  #header
  if File.exist?("./#{name}.h")
    File.delete("./#{name}.h")
  end

  File.open("./#{name}.h","w"){ |h|

    str = commentsOfFile("h","#{name}","#{author}")
    h.puts(str)

    str = headerFileContent(["#{clz}.h"],name,clz,prop_ins+prop_outs,[],[])
    h.puts(str)
  }
  
  #body
  if File.exist?("./#{name}.m")
    File.delete("./#{name}.m")
  end
  
  File.open("./#{name}.m","w"){ |h|
    
    str = commentsOfFile("m","#{name}","#{author}")
    h.puts(str)
    
    #import
    str = "#import \"#{name}.h\"\n\n"
    h.puts str
    
    #@implement
    str = "@implementation #{name}\n\n"
    h.puts str
    
    #dataParams
    str = "- (NSDictionary* )dataParams{\n\n    //todo:   \n\n    return nil; \n\n}\n"
    h.puts str
    
    #mtopParams
    str = "- (NSDictionary* )mtopParams{\n\n   //todo:    \n\n    return nil; \n\n}\n"
    h.puts str
    
    #method name
    str = "- (NSString* )methodName{\n\n    return @\"#{api}\"; \n\n}\n"
    h.puts str
    
    #useAuth
    str = "- (BOOL)useAuth{\n\n     return NO; \n\n}\n"
    h.puts str
    
    #page size
    str = "- (NSInteger)pageSize{\n\n     return 0; \n\n}\n"
    h.puts str
    
    #parse response
    str = "- (NSArray*)parseResponse:(id)JSON error:(NSError *__autoreleasing *)error{\n\n    return nil; \n\n}\n"
    h.puts str
    
    #@end
    str = "@end\n\n"
    h.puts str
    
  }

  
end




