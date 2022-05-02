#!/usr/bin/env python3
from os import path
from git import Repo
from jinja2 import Template


class Package:

    def __init__(self, path):
        self.path = path
        self.git_repo = self.get_git_repo()

    def get_git_repo(self):
        return Repo(self.path, search_parent_directories=True)

    def get_git_root(self):
        git_root = self.git_repo.git.rev_parse("--show-toplevel")
        return git_root

    def get_package_name(self):
        package_name = path.basename(self.get_git_root())
        return package_name

    def get_package_version(self):
        package_version = self.git_repo.tags[-1]
        return package_version

    def get_maintainer_name(self):
        maintainer_name = (self.git_repo.config_reader().get_value("user","name"))
        return maintainer_name
    

    def get_maintainer_email_address(self):
        maintainer_email_address = (self.git_repo.config_reader().get_value("user","email"))
        return maintainer_email_address


if __name__ == "__main__":
    current_git_root = Package("./")
    git_root = current_git_root.get_git_root()
    package_name = current_git_root.get_package_name()
    package_version = current_git_root.get_package_version()
    maintainer_name = current_git_root.get_maintainer_name()
    maintainer_email_address = current_git_root.get_maintainer_email_address()
    print(git_root)
    print(package_name)
    print(package_version)
    print(maintainer_name)
    print(maintainer_email_address)
