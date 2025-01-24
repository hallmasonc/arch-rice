# Simple Arch Setup and i3wm Rice

## Why?

I needed a simple way to install applications and setup my i3wm environment
after such a simple Arch Linux install using [```easy-arch```](https://github.com/hallmasonc/easy-arch) forked from the project
of the same name by [```classy-giraffe```](https://github.com/classy-giraffe). This repository also bridges the gap
between post-install Arch Linux and the final configurations found in my [```dotfiles```](https://github.com/hallmasonc/dotfiles)
repository.

## TODO

Check the ```TODO.md``` file to view upcoming changes to the repository and progress on current goals.

## How to use?

- View the aforementioned ```easy-arch``` and ```dotfiles``` repositories to see how I am setting up my Arch Linux installation.
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