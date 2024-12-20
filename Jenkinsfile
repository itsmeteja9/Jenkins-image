pipeline {
    environment {
        registry = "itsmeteja9/jenkins-image"
        registryCredential = 'dockerjenkinsintegration'
    }
    agent any

    stages {
        stage('Building our image') {
            steps {
                script {
                    dockerImage = docker.build("${registry}:${BUILD_NUMBER}")
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
                    // Initialize a counter for successful builds
                    def successfulBuilds = []
                    def build = currentBuild.previousBuild

                    // Loop through previous builds to find the successful ones
                    while (build != null && successfulBuilds.size() < 1) {
                        if (build.result == "SUCCESS") {
                            successfulBuilds.add(build.number)
                        }
                        build = build.previousBuild
                    }

                    // If successful builds were found, clean up their images
                    if (successfulBuilds.isEmpty()) {
                        echo "No previous successful builds found to clean up."
                    } else {
                        successfulBuilds.each { buildNumber ->
                            echo "Removing image from build ${buildNumber}"

                            // Check if the image exists using Docker's 'images' command
                            def imageExist = bat(script: "docker images -q ${registry}:${buildNumber}", returnStdout: true).trim()

                            // If the image exists, remove it
                            if (imageExist) {
                                echo "Image ${registry}:${buildNumber} exists, removing..."
                                bat "docker rmi ${registry}:${buildNumber}"
                            } else {
                                echo "Image ${registry}:${buildNumber} does not exist, skipping deletion."
                            }
                        }
                    }
                }
            }
        }
    }
}
