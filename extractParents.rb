class Extract_parents
	$not_a_merge_sha = ''

	def extract(pathProject, commit)
		i = 1
		parents = []
		parents.push(checkMerge(pathProject, commit))
		while(parents.length < 100)
			puts parents.length
				parents.push(checkMerge(pathProject, $not_a_merge_sha))
		end
		puts parents
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

Extract_parents.new.extract("/home/ess/test-analyser/LocalSupport", "fd64659f31b7f9e8ab6c01d0ef5c4461c2027875")
