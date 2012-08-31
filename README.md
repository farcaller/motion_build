# MotionBuild

[![Build Status](https://secure.travis-ci.org/farcaller/motion_build.png?branch=master)](http://travis-ci.org/farcaller/motion_build)
[![Dependency Status](https://gemnasium.com/farcaller/motion_build.png)](https://gemnasium.com/farcaller/motion_build)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/farcaller/motion_build)

This is an experiment to make a modern RubyMotion build system.

## Goals

1. All build steps are distinct rules and al the rules are documented.
2. It is simple to modify the build order without hacking in.
3. Support *simple* extensions of build process with gems.

## Concepts

### Rule

**Rule** is the main concept of this build system. A Rule can be *active?*, which
means that it should run this build sycle. A Rule can also have *dependencies*,
which are executed prior to main Rule's *run* method.

**FileRule** is an extension to **Rule**, that allows simple rules that take a
file and output another file. FileRule automatically tracks its *active?* status
based on file existence, mtimes and such.

### Project

**Project** hold all the info about a target that allows it to be built (this
might be actually renamed to Target).

Core concepts of Project are:

1. **Config**. This one holds project properties and build-time data required for
the build. It's based on a DSL for possible options and value validators. Options
can hold a default value, resolve it at runtime, or you can override it from local
config.

2. **Builder**. This is a pretty straightforward class, that manages all external
tools, performs command executions and also logs the required output.

3. **Root Rule**. As of now it's BuildProjectRule. It's the rule that fills in
all dependencies for project to be built successfully.

## Want to help?

I've started this as a concept project, but I feel now it has some real future.
The code in this repo is re-written from scratch and is mostly (*cough*) covered
by tests. At the moment it covers only the first step of RubyMotion build chain
-- the source files compilation. I'm going to add all other steps so it's a
drop-in replacement for the RubyMotion.

Have any ideas on this? Drop me a line.

Have any code to suggest? That's even more awesome, send me a pull request!
