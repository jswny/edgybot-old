#!/usr/bin/env bash

openssl aes-256-cbc -K $(echo "${DEPLOY_KEY_ENV_VAR_PREFIX}_key") -iv $(echo "${DEPLOY_KEY_ENV_VAR_PREFIX}_iv") -in "${DEPLOY_ARTIFACTS_DIR}"/deploy_key.enc -out "${DEPLOY_ARTIFACTS_DIR}"/deploy_key -d
chmod 600 "${DEPLOY_ARTIFACTS_DIR}"/deploy_key
ssh-add "${DEPLOY_ARTIFACTS_DIR}"/deploy_key
ssh-keyscan -t "$TRAVIS_SSH_KEY_TYPES" -H "$DEPLOY_SERVER" 2>&1 >> "${TRAVIS_HOME}"/.ssh/known_hosts
