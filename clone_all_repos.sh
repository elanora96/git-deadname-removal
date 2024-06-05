source ./config.sh

mkdir "$WORKING_DIR" && cd "$WORKING_DIR"

gh repo list "$USERNAME" --limit 100 --json nameWithOwner --jq '.[].nameWithOwner' | while read repo; do
    gh repo clone "$repo"
done
