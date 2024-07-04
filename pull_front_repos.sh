#!/bin/bash
export GH_USERNAME="mohamedkaram123"
export GH_TOKEN="<token>"

# Define an array of repository URLs
repos=(
    "https://$GH_USERNAME:$GH_TOKEN@github.com/KarzounApps/tiledesk-dashboard.git"
    "https://$GH_USERNAME:$GH_TOKEN@github.com/KarzounApps/design-studio.git"
    "https://$GH_USERNAME:$GH_TOKEN@github.com/KarzounApps/chat21-ionic.git"
    "https://$GH_USERNAME:$GH_TOKEN@github.com/KarzounApps/chat21-web-widget.git"
    "https://$GH_USERNAME:$GH_TOKEN@github.com/KarzounApps/dev_docker.git"
)

# Directory to clone repositories into
clone_dir="octobot"

# Create the directory if it doesn't exist
mkdir -p "$clone_dir"

# Change to the directory
cd "$clone_dir" || exit

# Iterate over the array and clone each repository
for repo in "${repos[@]}"; do
    echo "Checking and cloning $repo..."

    # Extract the repo name from the URL
    repo_name=$(basename "$repo" .git)

    # Check if the 'dev' branch exists
    if git ls-remote --exit-code --heads "$repo" dev >/dev/null 2>&1; then
        echo "Dev branch found. Cloning dev branch of $repo_name..."
        git clone -b dev "$repo"
    else
        echo "Dev branch not found. Cloning default branch of $repo_name..."
        git clone "$repo"
    fi

    echo "Finished cloning $repo_name"
    echo "------------------------"
done

# Copy the docker-compose.yml from the dev_docker repository
docker_compose_src="dev_docker/docker-compose.yml"
docker_compose_dest="."

if [ -f "$docker_compose_src" ]; then
    cp "$docker_compose_src" "$docker_compose_dest"
    echo "Copied docker-compose.yml to the parent directory"
else
    echo "docker-compose.yml not found in dev_docker repository"
fi

# Run docker compose
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
else
    echo "docker-compose.yml not found in the current directory"
fi
