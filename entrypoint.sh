#!/bin/bash

CURRENT_DIR=`pwd`

if [ -z "$1" ]; then    
    SOURCE="./_site"
else
    SOURCE=$1
fi

# ATTRIBUTES_OFF=$(tput sgr0)

# WEIGHT_BOLD=$(tput bold)
# DECOR_UNDERLINE=$(tput smul)
# DECOR_UNDERLINE_OFF=$(tput rmul)
# CLR_GREEN=$(tput setf 2)
# CLR_RED=$(tput setf 1)
# CLR_DEFAULT=$(tput setf 9)

function run_command {
    eval $1
}
# write a block start message ($1) in a standard format.
function start_block {        
    echo ""
    echo ""
    echo "🚩 $1"    
}

# writes a success message ($1) in a standard format
function end_block_success {
    echo "   ✅ $1"
}

# writes an error message ($1) in a standard format and exits the script
function end_block_failed {
    echo "   ❌ $1"
    exit 1
}

# writes a line in a block
function block_msg {
    echo "   ℹ️ $1"
}

# validates that the given environment variable name ($1) is in the environment - exits the script if not found
function check_env {
    if [ -z "$1" ]
    then
        end_block_failed "$1 is not set in environment. Exiting..."
    else        
        if [ "$2" = "secret" ]; then
            end_block_success "$1 found: ${!1:0:2}... "
        else
            end_block_success "$1 found: ${!1}"
        fi        
    fi     
}

# Makes sure that all the necessary environment variables are present.
function validate_environment {
    start_block "Checking for expected environment variables"
    check_env "SOURCE"
    check_env "AWS_ACCESS_KEY_ID" secret
    check_env "AWS_SECRET_ACCESS_KEY" secret
    check_env "S3_BUCKET_NAME"
    check_env "S3_BUCKET_PATH"

    start_block "Checking working directory for expected files(${CURRENT_DIR})"
    if test -f "_config.yml"; then
        end_block_success "Found jekyll config file"
    else
        end_block_failed "Unable to find the Jekyll config file in the current working directory."
    fi
}  

# Run the bundler install command to ensure that all dependencies are installed for 
#   the jekyll site.
function install_gems {
    start_block "Installing bundle gems (this can take up to 2 minutes)"
    bundle install > /dev/null
    end_block_success "Completed bundle install"
}

# Does a simple build of the jekyll site.
function build_site {
    start_block "Building jekyll site"
    jekyll build > /dev/null || end_block_failed "Jekyll build failed. Exiting..."
    end_block_success "Jekyll build done"
}

# Publishes to S3 using the s3_website gem which is assumed to be included in 
#   in the gemfile for the jekyll site.   There should also be an s3_website.yml
#   file which includes information about where to publish.  This also assumes
#   that the access key information is either in the environment or in the credentials
#   chain somewhere (e.g. a credentials file)
function publish_to_s3 {
    start_block "Publishing $SOURCE to S3 bucket named ${S3_BUCKET_NAME}/${S3_BUCKET_PATH}/"
    aws s3 cp $SOURCE "s3://${S3_BUCKET_NAME}/${S3_BUCKET_PATH}/" --recursive || end_block_failed "S3 Push failed. Exiting..."
    end_block_success "Published to s3"
}

chmod -R 777 .

validate_environment
install_gems
build_site
publish_to_s3


