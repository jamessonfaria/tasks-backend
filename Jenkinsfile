pipeline {
    agent any
    stages {
        stage ('Build Backend') {
            steps {
               bat 'mvn clean package -DskipTests=true'
            }
        }
        stage ('Unit Tests') {
            steps {
               bat 'mvn test'
            }
        }
        stage ('Sonar Analysis') {
            environment {
                scannerHome = tool 'SONAR_SCANNER'
            }
            steps {
               withSonarQubeEnv('Sonar_Local') { 
                    bat "${scannerHome}/bin/sonar-scanner -e -Dsonar.projectKey=DeployBack -Dsonar.host.url=http://192.168.1.5:9000 -Dsonar.login=5f3d4fb8e0775e4c0b29aed3e8db0407557f675e -Dsonar.java.binaries=target -Dsonar.coverage.exclusions=**/.mvn/**,**/src/test/**,**/model/**,**Application.java"
               }
            }
        }
        stage ('Quality Gate') {
            steps {
                sleep(5)
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true, credentialsId: 'SonarToken'
                }
            }
        }
        stage ('Deploy Backend') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'TomcatLogin', path: '', url: 'http://localhost:8001/')], contextPath: 'tasks-backend', war: 'target/tasks-backend.war'
            }
        }
        stage ('API Test') {
            steps {
                git branch: 'main', url: 'https://github.com/jamessonfaria/tasks-api-test.git'
                bat 'mvn test' 
            }
        }
    }
}

