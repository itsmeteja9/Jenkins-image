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
                    // Step 1: Get the list of image IDs (one per line)
                    def rawOutput = bat(
                        script: "docker images --format \"{{.ID}}\" --filter=reference='${registry}:*'",
                        returnStdout: true
                    ).trim()

                    echo "Raw image list:\n${rawOutput}"

                    // Step 2: Split the image list
                    def imageList = rawOutput.split(/\r?\n/).findAll { it?.trim() }

                    // Step 3: Remove the current image from the list
                    def currentImageId = dockerImage.id
                    echo "Current image ID: ${currentImageId}"

                    def oldImages = imageList.findAll { it != currentImageId }

                    if (oldImages) {
                        echo "Removing old images:\n${oldImages.join('\n')}"
                        oldImages.each { imageId ->
                            bat(script: "docker rmi -f ${imageId}")
                        }
                    } else {
                        echo "No old images to clean up."
                    }
                }
            }
        }
    }
}
