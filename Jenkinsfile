pipeline { 
    environment { 
        registry = "itsmeteja9/jenkins-image"  // Docker registry URL
        registryCredential = 'dockerjenkinsintegration'  // Jenkins credential for Docker registry
        dockerImage = '' 
    }
    agent any 

    stages { 

        stage('Building our image') { 
            steps { 
                script { 
                    // Build the Docker image and tag it with the current build number
                    dockerImage = docker.build("${registry}:$BUILD_NUMBER") 
                }
            } 
        }

        stage('Push image to DockerHub') { 
            steps { 
                script { 
                    // Push the newly built image to Docker Hub
                    docker.withRegistry('', registryCredential) { 
                        dockerImage.push() 
                    }
                } 
            } 
        }

        stage('Cleaning up Previous Images from Local Docker Engine') {
            steps {
                script {
                    // Get all the image IDs related to this registry (removes previous images)
                    def imageIds = bat(script: "docker images --filter=reference='${registry}:*' -q", returnStdout: true).trim()

                    // If there are any images, remove them (excluding the current image)
                    if (imageIds) {
                        echo "Removing previous images: ${imageIds}"
                        // Use Windows-compatible cleanup
                        bat """
                            FOR %%I IN (${imageIds}) DO docker rmi %%I
                        """
                    } else {
                        echo "No previous images found to remove."
                    }
                }
            }
        }
    }
}
