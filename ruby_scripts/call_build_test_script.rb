class Call_script

	def call(git_url, ruby_v, sha)
		result = ""
		system("#{__dir__}/script_clone_checkout.sh", git_url,sha)
		#system("#{__dir__}/script.sh", git_url, ruby_v)
		script = %x(#{__dir__}/script.sh #{git_url} #{ruby_v})
		if (!(/\d* scenarios \(.*\)/.match script).nil?)
			result = (/\d* scenarios \(.*\)/.match script).to_s
		end
		result
	end

	def read_merges(path, git_url, ruby_v)
		rep_name = (/[^\/]*$/.match(git_url)).to_s[0..-5]
		lines = read_file(path)
		lines.each do |line|
			if !line.include?("#")
				sha = line
				result = call(git_url, ruby_v, sha)
				if(result != "")
					text = "#{sha} - BUILD PASSED, #{result}\n"
					write_on_file(text, "#{rep_name}_results")
				else
					text = "#{sha} - BUILD FAILED, #{result}\n"
				end
			end
		end
	end

  def read_file(path)
    array_line = []
    File.foreach(path) do |line|
      array_line.push line
    end
    array_line
  end

  def write_on_file(text, path)
    File.open("#{path}", 'a') do |f|
      f.write text
    end
  end

end

Call_script.new.read_merges("/home/ess/taes-crystal/MergesLocalSupport", "https://github.com/AgileVentures/LocalSupport.git", "2.3.0")
