# To Do List:

- Clone Repos and Tools
- Optional Configurations

## Clone Repos and Tools

- [1. [ ```zsh``` ]](LOREM)
- [2. [ ```zsh-autosuggestions``` ]](LOREM)
- [3. [ ```zsh-syntax-highlighting``` ]](LOREM)
- [4. [ zsh-theme: ```powerlevel10k``` ]](LOREM)

### 1. [ ```zsh``` ]

- ``` chsh -s /usr/bin/zsh ```
- ``` sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ```
- ``` ```

### 2. [ ```zsh-autosuggestions``` ]

```
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

### 3. [ ```zsh-syntax-highlighting``` ]

```
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh_autosuggestions
```

### 4. [ zsh-theme: ```powerlevel10k``` ]

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