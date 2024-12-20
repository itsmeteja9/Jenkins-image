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
                    // Get the previous build number
                    def previousBuildNumber = currentBuild.number - 1
                    def previousImageTag = "${registry}:${previousBuildNumber}"

                    // Check if the image exists locally
                    def imageExists = bat(script: "docker images -q $previousImageTag", returnStdout: true).trim()

                    if (imageExists) {
                        echo "Removing previous image: $previousImageTag"
                        bat "docker rmi $previousImageTag"
                    } else {
                        echo "Image $previousImageTag not found locally."
                    }
                }
            }
        }
    }
}
