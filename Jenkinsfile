pipeline {
    agent any

    environment {
        // Default DB credentials
        DB_HOST = '172.31.44.171'          // your EC2 host IP
        DB_PORT = '5432'
        DB_USER = 'odoo_user_new'          // your DB user
        DB_PASS = credentials('db-cred')   // Jenkins secret credential ID
        UPGRADE_PATH = '/opt/migration/openupgrade/scripts'
        DOCKER_IMAGE = 'odoo-migration:latest'
    }

    parameters {
        string(name: 'DB_NAME', defaultValue: 'ngxsu_testing_db_2210_18_demo', description: 'Database name to migrate')
    }

    stages {
        stage('Checkout Repo') {
            steps {
                // Checkout your GitHub repo
                git branch: 'main', url: 'https://github.com/Abhinay3010/odoo-migration-pipeline.git', credentialsId: 'github-token'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE -f docker/Dockerfile .'
            }
        }

        stage('Run Migration') {
            steps {
                sh '''
                docker run --rm --network host \
                    -e DB_NAME=${DB_NAME} \
                    -e DB_HOST=${DB_HOST} \
                    -e DB_PORT=${DB_PORT} \
                    -e DB_USER=${DB_USER} \
                    -e DB_PASS=${DB_PASS} \
                    -e UPGRADE_PATH=${UPGRADE_PATH} \
                    -v $WORKSPACE:/workspace \
                    -w /workspace \
                    $DOCKER_IMAGE
                '''
            }
        }
    }

    post {
        success {
            echo 'Migration completed successfully!'
        }
        failure {
            echo 'Migration failed. Check the logs!'
        }
    }
}
