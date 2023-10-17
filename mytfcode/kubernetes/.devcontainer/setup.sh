if [ "${CODESPACES}" = "true" ]; then
    # Remove the default credential helper
    sudo sed -i -E 's/helper =.*//' /etc/gitconfig

    # Add one that just uses secrets available in the Codespace
    git config --global credential.helper '!f() { sleep 1; echo "username=${GITHUB_USER}"; echo "password=${GH_TOKEN}"; }; f'
fi

if [ -d "/var/run/docker.sock" ]; then
  # Grant access to the docker socket
  sudo chmod 666 /var/run/docker.sock
fi

sudo cp -R /tmp/.ssh-localhost/* ~/.ssh
sudo chown -R $(whoami):$(whoami) ~ || true ?>/dev/null
sudo chmod 400 ~/.ssh/*

git config --global core.editor vim
pre-commit install
pre-commit autoupdate

git config --global --add safe.directory /tf/caf
git config --global --add safe.directory /tf/caf/landingzones
git config --global --add safe.directory /tf/caf/landingzones/aztfmod
git config --global --add safe.directory /tf/caf/aztfmod

git config pull.rebase false 
git submodule update --init --recursive


# Customisation
echo "Enabling Starship"

sudo apt-get update
sudo apt-get install --no-install-recommends -y fonts-powerline fonts-firacode gh
curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

echo " Starship Configuration"

# echo 'eval "$(starship init zsh)"' >> /root/.zshrc \
# gh completion -s zsh > /usr/local/share/zsh/site-functions/_gh \
# gh config set editor "code --wait" \

# echo 'eval "$(starship init zsh)"' >> /home/$USERNAME/.zshrc \
mkdir -p /home/$USERNAME/.config
chown -R $USER_UID:$USER_GID /home/$USERNAME/.config
chmod -R 700 /home/$USERNAME/.config
cp /tf/caf/.devcontainer/starship.toml /home/$USERNAME/.config/
chown $USER_UID:$USER_GID /home/$USERNAME/.config/starship.toml 

echo " Starship Init"
eval "$(starship init zsh)"
