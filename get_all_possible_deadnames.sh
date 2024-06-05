source ./config.sh

cd "$WORKING_DIR"

extract_names() {
  git log --format='%aN%n%cN' | sort | uniq
}

TMP_FILE="tmp_name_list"

touch "$TMP_FILE"

for repo in */; do
  cd "$repo"
  extract_names >> ../"$TMP_FILE"
  cd ..
done

echo "Enter the lowest common unique denominator of your deadname"
read DEADNAME

readarray -t deadnames < <(sort "$TMP_FILE" | uniq | grep -i "$DEADNAME")

output="DEADNAMES=("
for name in "${deadnames[@]}"; do
  echo "Is \"$name\" a deadname to remove? [Y/y] Confirm [Anything Else] Skip"
  read choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    output+="\"$name\" "
  fi
done
output+=")"

echo "$output" >> ../config.sh

rm "$TMP_FILE"
