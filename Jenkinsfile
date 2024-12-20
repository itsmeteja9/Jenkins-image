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

                    docker.withRegistry( '', registryCredential ) { 

                        dockerImage.push() 

                 }

                } 

            }

        } 
stage('Cleaning up Previous 10 Images from Local Docker Engine') {
    steps {
        script {
            // Initialize a counter for successful builds
            def successfulBuilds = []
            def build = currentBuild.previousBuild
            // Loop through previous builds to find the successful ones
            while (build != null && successfulBuilds.size() < 10) {
                if (build.result == "SUCCESS") {
                    successfulBuilds.add(build.id as Integer)
                }
                build = build.previousBuild
            }

            // Delete images of the last 10 successful builds
            successfulBuilds.each { buildID ->
                echo "Removing image from build ${buildID}"
                // Check if the image exists
                def imageExist = bat(script: "docker images -q ${registry}:${buildID}", returnStdout: true).trim()
                if (imageExist) {
                    echo "Image ${registry}:${buildID} exists, removing..."
                    bat "docker rmi ${registry}:${buildID}"
                } else {
                    echo "Image ${registry}:${buildID} does not exist, skipping deletion."
                }
            }

            if (successfulBuilds.isEmpty()) {
                echo "No previous successful builds found to clean up."
            }
        }
    }
}
