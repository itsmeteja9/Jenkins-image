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
                    docker.withRegistry('', registryCredential) { 
                        dockerImage.push() 
                    }
                } 
            } 
        }

        stage('Cleaning up Previous Image from Local Docker Engine') {
            steps {
                script {
                    // Try to find the last successful build
                    def lastSuccessfulBuildID = null
                    def build = currentBuild.previousBuild
                    while (build != null) {
                        if (build.result == "SUCCESS") {
                            lastSuccessfulBuildID = build.id as String
                            break
                        }
                        build = build.previousBuild
                    }

                    if (lastSuccessfulBuildID) {
                        echo "Last successful build ID: ${lastSuccessfulBuildID}"
                        
                        // Check if the image exists before attempting to remove it
                        def imageExists = sh(script: "docker images -q $registry:${lastSuccessfulBuildID}", returnStdout: true).trim()
                        
                        if (imageExists) {
                            echo "Removing previous image: $registry:${lastSuccessfulBuildID}"
                            bat "docker rmi $registry:${lastSuccessfulBuildID}"
                        } else {
                            echo "Image $registry:${lastSuccessfulBuildID} not found locally."
                        }
                    } else {
                        echo "No previous successful build found."
                    }
                }
            }
        }
    }
}

