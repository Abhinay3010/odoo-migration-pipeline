pipeline {
  agent any

  parameters {
    string(name: 'DB_NAME', defaultValue: 'ngxsu_testing_db_2210_18_demo')
    string(name: 'DB_HOST', defaultValue: 'your-db-host')
  }

  environment {
    DOCKER_IMAGE = "odoo-migration:${env.BUILD_ID}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Image') {
      steps {
        script {
          docker.build(env.DOCKER_IMAGE, "-f docker/Dockerfile .")
        }
      }
    }

    stage('Run Migration') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'db-creds',
                           usernameVariable: 'DB_USER',
                           passwordVariable: 'DB_PASS')
        ]) {
          script {
            docker.image(env.DOCKER_IMAGE).inside("""
             -e DB_NAME=${params.DB_NAME}
             -e DB_HOST=${params.DB_HOST}
             -e DB_PORT=5432
             -e DB_USER=${DB_USER}
             -e DB_PASS=${DB_PASS}
             -e UPGRADE_PATH=/opt/migration/openupgrade/scripts
            """) {
              sh "/opt/migration/scripts/run_migration.sh"
            }
          }
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'logs/**', allowEmptyArchive: true
    }
  }
}
