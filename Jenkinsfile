pipeline {
  
  environment {
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
        sh '''
          docker rmi ${REPOSITORY}:${BUILD_NUMBER}
          rm *.json
          '''
      } // end steps
    } // end stage "clean up"

    
  } // end stages
} //end pipeline
