pipeline {
    agent {
        label 'kaniko-git'
    }

    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
        timestamps()
    }

    environment {
        CHART_VALUES_FILE = 'charts/django-app/values.yaml'
        TARGET_BRANCH = 'final-project'
        SOURCE_BRANCH = 'final-project'
        GIT_SSH_CREDENTIALS_ID = 'github-rsa-key'
        GIT_REPOSITORY_SSH = 'git@github.com:vmix-woolf/devops-final-project.git'
        GIT_USER_NAME = 'jenkins'
        GIT_USER_EMAIL = 'jenkins@example.com'
    }

    stages {
        stage('checkout') {
            steps {
                container('git') {
                    sshagent(credentials: ["${GIT_SSH_CREDENTIALS_ID}"]) {
                        sh '''
                            mkdir -p ~/.ssh
                            ssh-keyscan -t rsa,ecdsa,ed25519 github.com > ~/.ssh/known_hosts
                            chmod 700 ~/.ssh
                            chmod 644 ~/.ssh/known_hosts

                            git clone --branch "${SOURCE_BRANCH}" "${GIT_REPOSITORY_SSH}" .
                            git config --global --add safe.directory "${WORKSPACE}"
                            git status
                        '''
                    }
                }
            }
        }

        stage('detect automation commit') {
            steps {
                container('git') {
                    script {
                        String commitAuthor = sh(
                            script: 'git log -1 --pretty=%ae',
                            returnStdout: true
                        ).trim()

                        String commitMessage = sh(
                            script: 'git log -1 --pretty=%s',
                            returnStdout: true
                        ).trim()

                        env.SKIP_PIPELINE = (
                            commitAuthor == env.GIT_USER_EMAIL &&
                            commitMessage.startsWith('update django image tag to')
                        ).toString()

                        if (env.SKIP_PIPELINE == 'true') {
                            echo 'Skipping Jenkins automation commit.'
                        }
                    }
                }
            }
        }

        stage('generate image tag') {
            when {
                expression {
                    env.SKIP_PIPELINE != 'true'
                }
            }

            steps {
                container('git') {
                    script {
                        env.IMAGE_TAG = sh(
                            script: 'git rev-parse --short HEAD',
                            returnStdout: true
                        ).trim()
                    }

                    echo "Image tag: ${IMAGE_TAG}"
                }
            }
        }

        stage('build and push image with kaniko') {
            when {
                expression {
                    env.SKIP_PIPELINE != 'true'
                }
            }

            steps {
                container('kaniko') {
                    sh '''
                        test -n "${ECR_REPOSITORY}"
                        test -n "${AWS_REGION}"

                        /kaniko/executor \
                          --context "${WORKSPACE}/app" \
                          --dockerfile "${WORKSPACE}/app/Dockerfile" \
                          --destination "${ECR_REPOSITORY}:${IMAGE_TAG}" \
                          --destination "${ECR_REPOSITORY}:latest"
                    '''
                }
            }
        }

        stage('update helm values') {
            when {
                expression {
                    env.SKIP_PIPELINE != 'true'
                }
            }

            steps {
                container('git') {
                    sh '''
                        sed -i "s|^  tag:.*|  tag: ${IMAGE_TAG}|" "${CHART_VALUES_FILE}"

                        echo "Updated Helm image:"
                        grep -A 3 "^image:" "${CHART_VALUES_FILE}"
                    '''
                }
            }
        }

        stage('commit and push helm values') {
            when {
                expression {
                    env.SKIP_PIPELINE != 'true'
                }
            }

            steps {
                container('git') {
                    sshagent(credentials: ["${GIT_SSH_CREDENTIALS_ID}"]) {
                        sh '''
                            git config user.name "${GIT_USER_NAME}"
                            git config user.email "${GIT_USER_EMAIL}"

                            if git diff --quiet "${CHART_VALUES_FILE}"; then
                              echo "No Helm values changes to commit"
                              exit 0
                            fi

                            git add "${CHART_VALUES_FILE}"
                            git commit -m "update django image tag to ${IMAGE_TAG}"
                            git push origin HEAD:${TARGET_BRANCH}
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'CI pipeline completed successfully.'
        }

        failure {
            echo 'CI pipeline failed.'
        }
    }
}
