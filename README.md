curl -L https://nixos.org/nix/install | sh

git clone git@github.com:XNCOAISN/dotfiles.git ~/dotfiles
cd ~/dotfiles

sudo nix run nix-darwin -- switch --flake .#te