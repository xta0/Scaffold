#encoding:utf-8

module PARSER

require './core/renderer.rb'

def _err(str)
  puts "error:".red
  puts str
  exit
end

def _log(str)
  puts "...................................................\n"
  puts str
end


def PARSER::parse_json_file(json_path)

	_err "meta.json does not exist !!" if not File.exist?json_path

	##read meta data
	meta_json = nil
	begin
	f = File.read(json_path)
	meta_json = JSON.parse(f)
	rescue
	  puts "parse json file error"
	end

	PARSER::parse_json_obj(meta_json)


end

def PARSER::parse_json_obj(meta_json)


	_log "Begin Creating Files..."

	comment_hash = $comment_hash

	puts "meta:#{meta_json}" 

	meta_json.each{ |k,obj|

		puts "Creating #{k.upcase}..."

		if obj.kind_of?(Array)
			
			obj.each{ |hash|

				puts "Creating #{hash["class"]} at #{hash["filepath"]}..."

				renderer = Renderer.new(hash,comment_hash)
				renderer.render
			}
		
		else

			if obj.kind_of?(Hash)

				puts "Creating #{obj["class"]} at #{obj["filepath"]}..."
				renderer = Renderer.new(obj,comment_hash)
				renderer.render

			end

		end
	}

end

end