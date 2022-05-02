#!/usr/bin/env python3
import os
import git
from jinja2 import Template


class Package:

    def __init__(self, path):
        self.path = path

    def get_git_root(self):
        git_repo = git.Repo(self.path, search_parent_directories=True)
        git_root = git_repo.git.rev_parse("--show-toplevel")
        return git_root

    def get_package_name(self):
        return

    def get_package_version(self):
        return

    def get_maintainer_name(self):
        return

    def get_maintainer_email_address(self):
        return


if __name__ == "__main__":
    current_git_root = Package("./")
    git_root = current_git_root.get_git_root()
    print(git_root)
