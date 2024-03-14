pipeline {
    agent {
        node {
            label "${LABEL}"
            customWorkspace "${CUST_WRKSPC}"
        }
    }
    environment {
        DISABLE_AUTH = 'true'
        GIT_SSH_COMMAND = 'ssh -o StrictHostKeyChecking=accept-new'
    }
    stages {
        stage('Prerequisites') {
            steps {
                sh 'whoami'
                sh 'apt update'
                sh 'sudo apt-get install git -y'
                sh 'sudo apt-get install sshpass -y'
            }
        }
        stage('Pre-Check') {
            steps {
                sh 'sudo chmod -R 755 ./scripts'
                /* groovylint-disable-next-line LineLength */
                sh "./scripts/checkout_local_sources.sh repo:$REPO_NAME sshpass:$SSH_PASS server:$LOCAL_GIT_SERVER port:$SERVER_PORT path:$REPO_PATH"
                sh 'pwd'
                sh 'ls -lsa'
            }
        }
        stage('GPU Status Check') {
            steps {
                sh 'nvidia-smi'
            }
        }
    }
}
