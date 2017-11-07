def getParentsIfTrueMergeScenario(pathProject, commit)
    # o commit trata-se do hash (sha)
    parentsCommit = []
    #checkout no projeto. Eu pego o caminho pela localizaçao do arquivo travis, e depois, retiro ele
    Dir.chdir pathProject.to_s.gsub('.travis.yml','')
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

    return parentsCommit
end