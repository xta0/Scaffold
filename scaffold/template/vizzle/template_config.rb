#encoding:utf-8

module T_Config

require 'erb'

#{
# package_name:xxx
# proj:xxx
#}

def T_Config::renderH(hash)
  
  time = Time.new
  tmplate = <<-TEMPLATE

#ifndef <%= hash["proj"] %>_<%= hash["package_name"] %>_h
#define <%= hash["proj"] %>_<%= hash["package_name"] %>_h


#endif
  
  TEMPLATE
  
  erb = ERB.new(tmplate)
  erb.result(binding)
  
end



end