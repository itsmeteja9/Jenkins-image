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

       stage('Cleaning up Previous Images from Local Docker Engine') {
            steps {
                script {
                    // Remove all images from the registry, except for the current image being built
                    def existingImages = bat(script: "docker images --filter=reference='$registry:*' -q", returnStdout: true).trim()

                    if (existingImages) {
                        echo "Removing previous images: $existingImages"
                        bat "docker rmi $existingImages"
                    } else {
                        echo "No previous images found to remove."
                    }
                }
            }
        }
    }
}
