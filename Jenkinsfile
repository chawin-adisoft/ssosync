#!/usr/bin/env groovy
import hudson.model.*
import groovy.json.JsonSlurper

@Library('my-shared-library') _

// Set global variables
def AGENT_LABEL

def getAgentLabel() {
  withFolderProperties {
        AGENT_LABEL = "${env.AGENT_LABEL}"
  }
  return AGENT_LABEL
}

// Start Pipeline
pipeline {
  agent {
      node {
        // label getAgentLabel()
        label 'jenkins-node'
      }
  }

  stages {
    stage('Install SSO Sync command') {
      steps {
        script {
          sh 'make go-build'
          sh './ssosync -h'
        }
      }
    }

    stage('Add .env file') {
      steps {
        script {
          def credentialsName = "Adisoft/data/sso_sync"
          echo "Retrieve the .env secret from Vault credentialsName : ${credentialsName}"
          withVault([[$class: 'VaultSecret',
            path: "${credentialsName}",
            secretValues: [[vaultKey: 'data', envVar: 'dotENV']]]]) {
              if (dotENV?.trim()) {
                sh '''echo "$dotENV" | jq -r 'to_entries|map("\\(.key | ascii_upcase)=\\"\\(.value|tostring)\\"")|.[]' > .env'''
              } else {
                error("Vault ${credentialsName} key is empty or not found.")
              }
            }
        }
      }
    }

    stage('Add Google Credentials file') {
      steps {
        script {
          def credentialsName = "Adisoft/data/google-credentials"
          echo "Retrieve the .env secret from Vault credentialsName : ${credentialsName}"
          withVault([[$class: 'VaultSecret',
            path: "${credentialsName}",
            secretValues: [[vaultKey: 'data', envVar: 'dotENV']]]]) {
                sh '''echo "$dotENV" > google-credentials.json'''
            }
        }
      }
    }

    stage('Sync Google Workspace to AWS') {
      steps {
        script {
          sh 'bash sync-Googlworkspace-to-AWS.sh'
        }
      }
    }


  }
}
