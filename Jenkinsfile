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
            // Initialize build variable to track previous successful builds
            def build = currentBuild.previousBuild

            // Loop through previous successful builds (just one in this case)
            while (build != null && successfulBuilds.size() < 1) {
                if (build.result == "SUCCESS") {
                    // Try to remove image associated with the build number
                    def imageExist = bat(script: "docker images -q ${registry}:${build.number}", returnStdout: true).trim()

                    if (imageExist) {
                        echo "Removing image ${registry}:${build.number}"
                        bat "docker rmi ${registry}:${build.number}"
                    } else {
                        echo "Image ${registry}:${build.number} does not exist, skipping."
                    }
                    break
                }
                build = build.previousBuild
            }
        }
    }
}
    }
