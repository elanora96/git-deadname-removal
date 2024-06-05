USERNAME=$(gh api user --jq '.login')
CORRECT_NAME=$(git config user.name)
CORRECT_EMAIL=$(git config user.email)
WORKING_DIR=$(pwd)/"$USERNAME"
