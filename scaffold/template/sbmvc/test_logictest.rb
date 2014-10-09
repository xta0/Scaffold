require "./template_logictest.rb"


puts "==========================================="
puts "Logic Unit Test"
puts "==========================================="
#{
# class:xxx
# superclass:xxx 
# logicclass:Xxx
# sdkheader:xxx
#}

hash = {"class" => "LogicTest","superclass" => "XCTestCase","modelclass" => "MainPageLogic",
        "sdkheader" => "TBCitySBMVCConfig"}
  
puts "Hash Value : #{hash}"
puts "\n"

m = T_LogicTest::renderM(hash)
puts m
