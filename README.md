[![Build Status](https://secure.travis-ci.org/vderyagin/nrename.png)](http://travis-ci.org/vderyagin/nrename)
[![Dependency Status](https://gemnasium.com/vderyagin/nrename.png)](https://gemnasium.com/vderyagin/nrename)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/vderyagin/nrename)

# Nrename

Command-line utility for renaming numbered files.

## Installation ##

```
gem install nrename
```

## Compatibility ##

This gem does not have any external runtime dependencies, nor does it use any
fancy language features/syntax, so it works on pretty much every Ruby
implementation out there.

## Description ##


When you have a set of files like:

```
1.txt
2.txt
10.txt
11.txt
99.txt
100.txt
```

it's hard to get a list of them in order (from `1.txt` to `100.txt`). Shell of
file manager will usually sort them starting from first symbol in filename,
like this:

```
1.txt
10.txt
100.txt
11.txt
2.txt
99.txt
```

Nrename lets you rename such files so that they have equal number of digits in
names:

```
001.txt
002.txt
010.txt
011.txt
099.txt
100.txt
```

## Usage ##

```
$ nrename --help
Usage: nrename [OPTINS] DIR...

Options:
    -X, --execute                    Do actual work
    -R, --recursive                  Process given directories recursively
    -N, --numbers-only               Leave only numbers in file name
    -D, --rename-dirs                Rename only directories instead of regular files
        --renumber                   Renumber files from starting from 1 and on
        --regexp REGEXP              Use REGEXP to match filenames
    -v, --[no-]verbose               Run verbosely
    -h, --help                       Display this message
        --version                    Display version
```
