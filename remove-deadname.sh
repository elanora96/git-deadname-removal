source ./config.sh

cd "$WORKING_DIR"

for repo in */; do
    cd "$repo"
    readarray -t repo_remotes < <(git remote -v | awk '{print $1, $2}' | uniq)
    echo "$repo_remotes" >> ../remotes.txt
    cd ..
done

for DEADNAME in "${DEADNAMES[@]}"; do
    for repo in */; do
        cd "$repo"
        git filter-repo --force --commit-callback '
            def set_identity(c):
                if c.author_name == b"'"$DEADNAME"'":
                    c.author_name = b"'"$CORRECT_NAME"'"
                    c.author_email = b"'"$CORRECT_EMAIL"'"
                if c.committer_name == b"'"$DEADNAME"'":
                    c.committer_name = b"'"$CORRECT_NAME"'"
                    c.committer_email = b"'"$CORRECT_EMAIL"'"
            set_identity(commit)
        '
        cd ..
    done
done

idx=1

for repo in */; do
    cd "$repo"
    git remote add $(sed -n ""${idx}"p" ../remotes.txt)
    default_branch = git remote show $(git remote -v | awk '{print $2}') | sed -n '/HEAD branch/s/.*: //p'
    git push --force origin "$default_branch"
    cd ..
    let idx=${idx}+1
done

rm ./remotes.txt
sed -i '/DEADNAMES/d' config.sh
