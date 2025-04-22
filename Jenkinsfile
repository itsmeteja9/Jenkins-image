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
                    // Get all image IDs that match the registry
                    def imageIds = bat(
                        script: "docker images --format \"{{.ID}}\" --filter=reference='${registry}:*'",
                        returnStdout: true
                    ).trim()

                    if (imageIds) {
                        def currentImageId = dockerImage.id
                        def imageList = imageIds.split(/\r?\n/).findAll { it != currentImageId }

                        if (imageList) {
                            echo "Removing previous images (excluding current build):\n${imageList.join('\n')}"
                            imageList.each { imageId ->
                                bat "docker rmi -f ${imageId}"
                            }
                        } else {
                            echo "No old images to remove. Only current build image is present."
                        }
                    } else {
                        echo "No previous images found to remove."
                    }
                }
            }
        }
    }
}
