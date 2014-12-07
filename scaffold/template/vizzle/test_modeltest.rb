require "./template_modeltest.rb"


puts "==========================================="
puts "Test ModelUnitTest"
puts "==========================================="
#{
# class:xxx
# superclass:xxx 
# modelclass:Xxx
# sdkheader
#}

hash = {"class" => "ListModelTest","superclass" => "XCTestCase","modelclass" => "ListModel",
        "sdkheader" => "VizzleConfig.h"}
  
puts "Hash Value : #{hash}"
puts "\n"

m = T_ModelTest::renderM(hash)
puts m
