pipeline { 
    environment { 
        registry = "itsmeteja9/jenkins-image"
        registryCredential = 'dockerjenkinsintegration'
        dockerImage = '' 
    }
    agent any 

    stages { 
        stage('Cleaning up Previous Images from Local Docker Engine') {
            steps {
                script {
                    // Get a list of image IDs matching the registry
                    def imageIds = bat(script: "docker images --filter=reference='itsmeteja9/jenkins-image:*' -q", returnStdout: true).trim()

                    // If there are any images, remove them
                    if (imageIds) {
                        echo "Removing previous images: ${imageIds}"
                        bat "docker rmi ${imageIds}"
                    } else {
                        echo "No previous images found to remove."
                    }
                }
            }
        }

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
    }
}
