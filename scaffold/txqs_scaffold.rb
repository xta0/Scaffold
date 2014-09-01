require 'json'
require 'pp'
require './txqs_controller.rb'
require './txqs_model.rb'
require './txqs_response.rb'


def printSepLine(str)

  puts "...................................................\n"
  puts str + "\n"
end

BEGIN{puts "SCAFFOLDING..."}

printSepLine("env: #{RUBY_PLATFORM} ")

##read meta data
begin
f = File.read("./meta.json")
response = JSON.parse(f)
rescue
  puts "parse json file error"
end

#author
author = response["author"]


#create controller
printSepLine("create controller:")
response["controller"].each{|controller|

  name = controller["name"]
  clz  = controller["class"]
  pros = controller["protocols"]
  models = controller["models"]
  datasource = controller["datasource"]
  delegate = controller["delegate"]
   
  #create files
  createControllers(name,clz,pros,models,datasource,delegate,author)
 
}

#create model
printSepLine("create models:")
response["model"].each{ |model|
  
  name = model["name"]
  clz  = model["class"]
  api  = model["api"]
  v    = model["v"]
  ins  = model["in"]
  outs = model["out"]
  #create models
  createModels(name,clz,api,v,ins,outs,author)
}

#create items
printSepLine("create items:")
response["item"].each{|item|
  
  name = item["name"]
  clz  = item["class"]
  resp = item["response"]
  
  #create items
  createItems(name,clz,resp,author)
}

#create views
printSepLine("create views:")
xib = response["view"]

if(xib)
  system "ruby txqs_response.rb #{xib} #{author}"
end

END{puts "SCAFFOLDING..."}
