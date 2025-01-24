# To Do List:

- Clone Repos and Tools
- Optional Configurations

## Clone Repos and Tools

- [1. [ aur helper: ```yay``` ]](LOREM)
- [2. [ ```dotfiles``` ]](LOREM)
- [3. [ ```stow``` config files ]](LOREM)
- [4. [ ```alacritty``` theme ]](LOREM)
- [5. [ ```rofi``` theme ]](LOREM)
- [6. [ ```zsh``` ]](LOREM)
- [7. [ ```zsh-autosuggestions``` ]](LOREM)
- [8. [ ```zsh-syntax-highlighting``` ]](LOREM)
- [9. [ zsh-theme: ```powerlevel10k``` ]](LOREM)

### 1. [ ***DONE: aur helper: ```yay``` ]

- Clone the yay repository.
```
git clone https://aur.archlinux.org/yay.git
```
- Change directory into the newly cloned repository.
```
cd yay
```
- Run the follwoing command to build ```yay```.
```
makepkg -si
```

### 2. [ ```dotfiles``` ]

- Clone ```dotfiles``` from personal Github repository. Make sure to specify a branch name.
```
git clone -b [branch name] https://github.com/hallmasonc/dotfiles ~/.dotfiles
```

### 3. [ ```stow``` config files ]

### 4. [ ```alacritty``` theme ]

- Run the following script to download the ```alacritty``` gruvbox theme.
```
bash ~/.config/alacritty/get-themes.sh
```

### 5. [ ```rofi``` theme ]

- ``` git clone --depth=1 https://github.com/adi1090x/rofi.git ~/.config/rofi.git ```
- ``` mkdir -p ~/.config/rofi.git/fonts ~/.config/rofi.git/files ```
- ``` cd ~/.config/rofi.git ```
- ``` bash ./setup.sh ```
- ``` export PATH=$HOME/.config/rofi/scripts:$PATH ```

### 6. [ ```zsh``` ]

- ``` chsh -s /usr/bin/zsh ```
- ``` sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ```
- ``` ```

### 7. [ ```zsh-autosuggestions``` ]

```
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

### 8. [ ```zsh-syntax-highlighting``` ]

```
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh_autosuggestions
```

### 9. [ zsh-theme: ```powerlevel10k``` ]

- Clone the following Github repository 
``` git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ```
- Now edit the ```ZSH_THEME``` line in ```~/.zshrc``` file to add powerlevel10k as the theme.
``` nano ~/.zshrc ```
``` ZSH_THEME="powerlevel10k/powerlevel10k" ```
- Restart your terminal and run the following command. Follow the prompts on screen to configure your shell to you liking.
``` p10k configure ```

## Optional Configurations

- [ 1. [```neofetch``` at terminal start]](LOREM)

### 1. [```neofetch``` at terminal start]

- Add the follwoing line and comment to the ```~/.zshrc``` file
```
# Run neofetch at terminal startup
neofetch
```