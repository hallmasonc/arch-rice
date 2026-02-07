# Simple Arch Setup and Swaywm Rice

## Why?

I needed a simple way to install some base applications and setup my Swaywm environment.
This repo bridges the gap between a generalized installation script, [```arch-mage```](https://github.com/hallmasonc/arch-mage)
and a final configurations found in my [```dotfiles```](https://github.com/hallmasonc/dotfiles) repository.

## TODO

Check the ```TODO.md``` file to view upcoming changes to the repository and progress on current goals.

## How to use?

- View the aforementioned ```arch-mage``` and ```dotfiles``` repositories to see how I am setting up my Arch Linux installation.
This will give you more insight into how this script is intended to be used post-install.

- Use the following command to get the latest release of the ```main``` branch:
```
git clone https://github.com/hallmasonc/arch-rice
```

- For the test branch of the repository with the latest changes use this command:
```
git clone -b test https://github.com/hallmasonc/arch-rice
```

- Once cloned, change directory to the cloned repository and run the ```post-install.sh``` script from there.
```
cd arch-rice
bash post-install.sh
```