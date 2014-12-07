#encoding:utf-8

require 'json'
require 'fileutils'
require 'yaml'
require './core/parser.rb'
require './core/command.rb'
require './core/factory.rb'

def _err(str)
  puts "error:"
  puts str
  exit
end

def _log(str)
  puts "...................................................\n"
  puts str
end


#define some global values
$proj_json      = nil
$proj_name   	= nil
$comp_name   	= nil
$author_name 	= nil
$clz_prefix  	= nil
$sdk_name    	= nil
$template       = nil
$comment_hash   = nil


#parse command line
options = CommandLineParse.parse(ARGV)
puts options.inspect

config_path = options[:optional_package_path]
config_path = "./proj_config/vizzle.json" if not config_path

#parse json
begin
f = File.read(config_path)
  $proj_json = JSON.parse(f)
rescue
  _err "Parse #{config_path} failed"
end

#load global values
_log($proj_json)

$proj_name   = $proj_json["proj"] ? $proj_json["proj"] : ""
$comp_name   = $proj_json["comp"] ? $proj_json["comp"] : ""
$author_name = $proj_json["author"] ? $proj_json["author"] : ENV['USER']
$clz_prefix  = $proj_json["clz_prefix"] ? $proj_json["clz_prefix"] : ""
$sdk_name    = $proj_json["sdk"] ? $proj_json["sdk"] : ""
_err "Missing SDK name in config file!" if $sdk_name.length == 0

#get yaml
_log("Read YAML File : ./yml/#{$sdk_name.downcase}.yml")
yaml_path = "./yml/#{$sdk_name.downcase}.yml"
_err "Missing #{$sdk_name.downcase}.yml in ./yml/" if not File.exist?(yaml_path)
$template = YAML.load(File.read(yaml_path))

#check yaml
_err "SDK name is inconsistant!!!" if $template[:template].downcase != $sdk_name.downcase

#create comment hash
$comment_hash 				= Hash.new
$comment_hash["class"] 		= ""
$comment_hash["comp"] 		= $comp_name
$comment_hash["proj"] 		= $proj_name
$comment_hash["author"] 	= $author_name
$comment_hash["tpath"] 		= "./template/#{$sdk_name.downcase}/template_#{$template[:comment][:template]}.rb"
$comment_hash["namespace"] 	= "#{$template[:comment][:namespace]}"


#get type of creation
type = options[:type]

BEGIN{puts "......BEGIN SCAFFOLDING......"}

if type == "package"

	_err "Can not find project config file!" if not config_path

	meta_hash = Factory.createPackage(options)

	package_name = options[:package_name]
	meta_json_path = "./#{package_name}/config/#{package_name.downcase}_meta.json"
	_log "create meta.json:#{meta_json_path}"

	meta_json = JSON.pretty_generate(meta_hash)
	File.delete meta_json_path if File.exist? meta_json_path 
	File.open(meta_json_path, "w") { |io| io.puts meta_json  }

	PARSER::parse_json_file(meta_json_path)

elsif type == "class"

	meta_hash = Factory.createClass(options)
	PARSER::parse_json_obj(meta_hash)

end

END{puts "......END SCAFFOLDING......"}

