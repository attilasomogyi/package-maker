from git import Repo
from src.package_maker.package_maker import Package
from tempfile import TemporaryDirectory


def setup_module(module):
    global test_repository_root
    global tempdir
    tempdir = TemporaryDirectory()
    test_repository_root = tempdir.name
    global test_git_repository
    test_git_repository = Repo.init(test_repository_root)
    global test_git_repository_root_path
    test_git_repository_root_path = test_repository_root+"/.git"
    global test_git_root
    test_git_root = Package(test_git_repository_root_path)


def teardown_module(module):
    tempdir.cleanup()


def test_get_git_root():
    assert test_git_root.get_git_root() == test_repository_root
