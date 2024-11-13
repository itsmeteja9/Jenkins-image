FROM jenkins/jenkins:lts-jdk17

WORKDIR /var/jenkins_home/plugins/

# Copy the plugins into the working directory
COPY ./plugins/docker-workflow.jpi /var/jenkins_home/plugins/

# Expose the default SonarQube port
EXPOSE 4000

# Start SonarQube
ENTRYPOINT ["/usr/bin/tini" "--" "/usr/local/bin/jenkins.sh"]
