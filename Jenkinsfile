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
                    // Find the last successful build's ID
                    def lastSuccessfulBuildID = 0
                    def build = currentBuild.previousBuild
                    while (build != null) {
                        if (build.result == "SUCCESS") {
                            lastSuccessfulBuildID = build.id as Integer
                            break
                        }
                        build = build.previousBuild
                    }

                    if (lastSuccessfulBuildID > 0) {
                        println "Removing image from previous successful build: ${registry}:${lastSuccessfulBuildID}"
                        // Ensure image exists before trying to remove it
                        def imageExist = sh(script: "docker images -q ${registry}:${lastSuccessfulBuildID}", returnStdout: true).trim()
                        if (imageExist) {
                            sh "docker rmi ${registry}:${lastSuccessfulBuildID}"
                        } else {
                            echo "Image ${registry}:${lastSuccessfulBuildID} does not exist locally."
                        }
                    } else {
                        echo "No previous successful build found, skipping cleanup."
                    }
                }
            }
        }
    }
}
