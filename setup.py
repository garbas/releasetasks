#!/usr/bin/env python
# -*- coding: utf-8 -*-


try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

with open('VERSION') as f:
    version = f.read().strip()

with open('README.rst') as f:
    long_description = f.read()


def read_requirements(file_):
    lines = []
    with open(file_) as f:
        for line in f.readlines():
            line = line.strip()
            if line.startswith('-e ') or line.startswith('http://') or line.startswith('https://'):
                lines.append(line.split('#')[1].split('egg=')[1])
            elif line.startswith('#') or line.startswith('-'):
                pass
            else:
                lines.append(line)
    return lines


setup(
    name='releasetasks',
    version=version,
    description="""Mozilla Release Promotion Tasks contains code to generate
    release-related Taskcluster graphs.""",
    long_description=long_description,
    author="Mozilla Release Engineering",
    author_email='release@mozilla.com',
    url='https://github.com/mozilla-releng/releasetasks',
    packages=[
        'releasetasks',
    ],
    package_dir={'releasetasks':
                 'releasetasks'},
    include_package_data=True,
    install_requires=read_requirements('requirements.txt'),
    license="MPL",
    zip_safe=False,
    keywords='releasetasks',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Programming Language :: Python :: 2.7',
    ],
    test_suite='tests',
    tests_require=read_requirements('requirements-dev.txt'),
)
