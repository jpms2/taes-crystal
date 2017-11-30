class Merge_left_right


	def merge(right, left, git_url, ruby_v)
		result = ""		
		rep_name = (/[^\/]*$/.match(git_url)).to_s[0..-5]
		Dir.chdir "#{__dir__.to_s}/#{rep_name}"
		system("git stash")
		system("git checkout #{right}")
		system("git merge #{left}")
		#Dir.chdir "#{__dir__.to_s}/.."
		#script = %x(#{__dir__}/script.sh #{git_url} #{ruby_v})
		#if (!(/\d* scenarios \(.*\)/.match script).nil?)
		#	result = (/\d* scenarios \(.*\)/.match script).to_s
		#end
		#result
	end

	def read_merges(path, git_url, ruby_v)
		rep_name = (/[^\/]*$/.match(git_url)).to_s[0..-5]
		lines = read_file(path)
		left = ""
		result = ""
		text = ""
		i = 1
		merge_sha = false
		lines.each do |line|
			if !line.include?("#")
				if merge_sha != true
					if left != ""
						result = merge(line,left, git_url, ruby_v)
						left = ""
						if(result != "")
							text = "Merge #{i} - BUILD PASSED, #{result}\n"
							write_on_file(text, "#{rep_name}_merge_results")
							i = i + 1
						else
							text = "Merge #{i} - BUILD FAILED, #{result}\n"
							i = i + 1
						end
					else
						left = line
					end
				else
					merge_sha = false
				end
			else
				merge_sha = true
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

Merge_left_right.new.read_merges("/home/ess/taes-crystal/MergesLocalSupport", "https://github.com/AgileVentures/LocalSupport.git", "2.3.0")
