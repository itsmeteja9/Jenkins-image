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
                    // Get image IDs related to the registry
                    def imageIdsOutput = bat(
                        script: "docker images --format \"{{.ID}}\" --filter=reference='${registry}:*'",
                        returnStdout: true
                    ).trim()

                    def imageList = imageIdsOutput.split(/\r?\n/).findAll { it?.trim() }

                    // Get the actual image ID of the current build image
                    def currentImageIdOutput = bat(
                        script: "docker inspect --format=\"{{.Id}}\" ${registry}:${BUILD_NUMBER}",
                        returnStdout: true
                    ).trim()

                    echo "Current image ID: ${currentImageIdOutput}"
                    echo "All matching image IDs:\n${imageList.join('\n')}"

                    def oldImages = imageList.findAll { it != currentImageIdOutput }

                    if (oldImages) {
                        echo "Removing old images:\n${oldImages.join('\n')}"
                        oldImages.each { imageId ->
                            // Correct the 'docker rmi' command to only take the image IDs
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
