# .dotfiles
My personal dotfiles for Linux distros.

## Installation
No guarantees anything will work as expected :)
```bash
git clone --recurse-submodules git@github.com:tkozakas/.dotfiles.git && cd .dotfiles && chmod +x main.sh scripts/*.sh && ./main.sh
```

## Updating Submodules
All submodules are configured to track the master branch. To update all submodules to the latest master:
```bash
git submodule update --remote --merge
```

Then commit and push the updates:
```bash
git add .
git commit -m "Update submodules to latest master"
git push
```
