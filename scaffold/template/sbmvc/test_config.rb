require "./template_config.rb"

puts "==========================================="
puts "Test Config"
puts "==========================================="

#{
# package_name:xxx
# proj:xxx
#}
hash = {"package_name" => "Test",
        "proj" => "TestProj"}
  
puts "Hash Value : #{hash}"
puts "\n"

h = T_Config::renderH(hash)
puts h
