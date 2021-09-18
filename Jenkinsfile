pipeline {
  
  environment {
    //
    // shouldn't need the registry variable unless you're not using dockerhub
    // registry = 'docker.io'
    //
    // change this HUB_CREDENTIAL to the ID of whatever jenkins credential has your registry user/pass
    // first let's set the docker hub credential and extract user/pass
    // we'll use the USR part for figuring out where are repository is
    //HUB_CREDENTIAL = "docker-hub"
    // use credentials to set DOCKER_HUB_USR and DOCKER_HUB_PSW
    //DOCKER_HUB = credentials("${HUB_CREDENTIAL}")
    // change repository to your DockerID
    REPOSITORY = "syft-sbom-demo"
  } // end environment
  
  agent any
  stages {
    
    stage('Checkout SCM') {
      steps {
        checkout scm
      } // end steps
    } // end stage "checkout scm"
    
    stage('Build image and tag with build number') {
      steps {
        script {
          dockerImage = docker.build REPOSITORY + ":${BUILD_NUMBER}"
        } // end script
      } // end steps
    } // end stage "build image"
    
    stage('Generate SBOM with syft') {
      steps {
        script {
          sh 'syft -o spdx-json ${REPOSITORY}:${BUILD_NUMBER} > sbom-spdx-${BUILD_NUMBER}.json'
          archiveArtifacts '*.json'
        } // end script
      } // end steps
    } // end stage "generate sbom"
    

    stage('Clean up') {
      // delete the images locally
      steps {
        sh 'docker rmi ${REPOSITORY}:${BUILD_NUMBER}'
      } // end steps
    } // end stage "clean up"

    
  } // end stages
} //end pipeline
