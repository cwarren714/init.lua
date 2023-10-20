### Stock install for neovim with xdebug support ### 
You can follow instructions for ubuntu here:
https://github.com/nodesource/distributions#installation-instructions

To get xdebug working, make sure to install to ~/ following directions here:
https://grumpy-learning.com/blog/2023/04/03/neovim-and-xdebug/
It needs to be set properly in the setup/config. 

Also make sure the pathMapping is set properly (defaults to www/ directory in the working dir).

Finally, make sure to have ripgrep installed so telescope works as expected:
```
sudo apt-get install ripgrep
```
