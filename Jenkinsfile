node('PyNode'){
    stage('Git Checkout'){
        git branch: 'main', url: 'https://github.com/SilentEntity/CaseApp.git'
    }
    stage('Setting up Environment'){
        sh '''#!/bin/bash
        echo $PATH
        pip3 install virtualenv;
        virtualenv -p python3 cicd_env;
        source cicd_env/bin/activate;
        pip3 install -r requirements.txt;
        pip3 list'''
    }
    stage('BATS'){
        sh '''#!/bin/bash
        source cicd_env/bin/activate;
        pytest -v'''
    }
    stage('Package the Code'){
        println "Package the code"
        sh '''#!/bin/bash
        source cicd_env/bin/activate;
        python3 setup.py sdist bdist_wheel 
        '''
    }
    stage('Upload to Nexus Repo'){
        println "==Uploading the code=="
        sh '''#!/bin/bash
        source cicd_env/bin/activate;
        twine upload dist/* --repository-url $NEXUS_REPO_URL -u $NEXUS_USER -p $NEXUS_PASSWORD
        '''
    }
    stage('Archive the artifacts'){
        println "===Archive==="
        archiveArtifacts artifacts: 'dist/*', followSymlinks: false
    }
}