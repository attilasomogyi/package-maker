#!/usr/bin/env python
import os
import git
from jinja2 import Template
class Git:

    def __init__(self, path):
        self.path = path

    def get_git_root(self):
        git_repo = git.Repo(self.path, search_parent_directories=True)
        git_root = git_repo.git.rev_parse("--show-toplevel")
        return git_root

if __name__ == "__main__":
    current_git_root = Git("./")
    git_root = current_git_root.get_git_root()
    print(git_root)
