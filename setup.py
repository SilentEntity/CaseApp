import setuptools
from distutils.core import setup

setup(
    # Application name:
    name="CaseApp",

    # Version number (initial):
    version="0.1.0",

    # Application author details:
    author="Silent",
    author_email="Silent@me",

    # Packages
    packages=["apps"],

    # Include additional files into the package
    include_package_data=True,

    # Pypi Repo Details
    url="",

    #
    # license="LICENSE.txt",
    description="Sample Flask App.",

    # Dependent packages (distributions)
    install_requires=[
        "flask",
    ],
    entry_points={
        'console_scripts': [
            'caseapp = apps.main:app_cli',
        ],
    },
)
