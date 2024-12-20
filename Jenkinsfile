pipeline { 

    environment { 

        registry = "itsmeteja9/jenkins-image" 

        registryCredential = 'dockerjenkinsintegration' 

        dockerImage = '' 

    }
    agent any 

    stages { 


        stage('Building our image') { 

            steps { 

                script { 

                    dockerImage = docker.build registry + ":$BUILD_NUMBER" 

                }
            } 
        }

        stage('Push image to DockerHub') { 

            steps { 

                script { 

                    docker.withRegistry( '', registryCredential ) { 

                        dockerImage.push() 

                 }

                } 

            }

        } 

         stage('Cleaning up Previous Image from Local Docker Engine') {
    steps {
        script {
            // Stop and remove the container first
            // bat "docker stop sonarqube1"
           // bat "docker rm sonarqube1"
        def lastSuccessfulBuildID = 0
        def build = currentBuild.previousBuild
        while (build != null) {
            if (build.result == "SUCCESS")
            {
                lastSuccessfulBuildID = build.id as Integer
                break
            }
            build = build.previousBuild
        }
        println lastSuccessfulBuildID
            // Now remove the image
            bat "docker rmi $registry:${lastSuccessfulBuildID}"
        }
    }
}
    }

}
