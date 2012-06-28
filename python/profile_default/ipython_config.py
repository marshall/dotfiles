import os
import sys

# __file__ isn't available in ipython_config.py, so have to use DOTFILES
dotfiles_dir = os.environ["DOTFILES"]
pythonrc = os.path.join(dotfiles_dir, "python", "pythonrc.py")

# Reuse interactive terminal helpers from pythonrc.py
execfile(pythonrc)
