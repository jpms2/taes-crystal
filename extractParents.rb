class Extract_parents
	$not_a_merge_sha = ''

	def extract(pathProject, commit)
		i = 0
		parents = []
		text = ""
		parents.push(checkMerge(pathProject, commit))
		while(parents.length < 1000)
			puts parents.length
				parents.push(checkMerge(pathProject, $not_a_merge_sha))
		end
		while (i < parents.length)
			if parents[i] != []
				text = text + "########################################\n"
				text = text + parents[i][0] + "\n" + parents[i][1] + "\n" + parents[i][2] + "\n"
			end
			i = i + 1
		end
		write_on_file(text, "/home/ess/taes-crystal/MergesLocalSupport")
	end 

  def write_on_file(text, path)
    File.open("#{path}", 'a') do |f|
      f.write text
    end
  end

	def makeCheckout(pathProject, commit)
		Dir.chdir pathProject.to_s
		stash = %x(git stash)
		checkout = %x(git checkout #{commit})
	end

	def checkMerge(pathProject, commit)
		makeCheckout(pathProject, commit)
		parents = getParentsIfTrueMergeScenario(pathProject, commit)
		if parents.length > 2
			$not_a_merge_sha = parents[2]
			return parents
		else
			$not_a_merge_sha = parents[1]
			return []
		end
	end

	def getParentsIfTrueMergeScenario(pathProject, commit)
		# o commit trata-se do hash (sha)
		parentsCommit = []
		parentsCommit.push(commit)
		#checkout no projeto. Eu pego o caminho pela localizaçao do arquivo travis, e depois, retiro ele
		Dir.chdir pathProject.to_s
		commitType = %x(git cat-file -p #{commit})
		commitType.each_line do |line|
		    #quando chega na linha com author significa que todos os parents ja foram encontrados 
		    if(line.include?('author'))
		        break
		    end
		    if(line.include?('parent'))
		        commitSHA = line.partition('parent ').last.gsub("\n","").gsub(' ','').gsub('\r','')
		        parentsCommit.push(commitSHA)
		    end
		end
		parentsCommit
	end

end

Extract_parents.new.extract("/home/ess/taes-crystal/LocalSupport", "fd64659f31b7f9e8ab6c01d0ef5c4461c2027875")
