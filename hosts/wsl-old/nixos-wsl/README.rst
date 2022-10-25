============
NixOS on WSL
============

A minimal root filesystem for running NixOS on WSL. It can be used with
DistroLauncher_ as ``install.tar.gz`` or as input to ``wsl --import --version
2``.


Quick start
===========

First, `download the latest release's installer
<https://github.com/nix-community/NixOS-WSL/releases/latest/download/nixos-wsl-installer.tar.gz>`_.

Then open up a Terminal, PowerShell or Command Prompt and run::

   wsl --import NixOS .\NixOS\ nixos-wsl-installer.tar.gz --version 2

This sets up a new WSL distribution ``NixOS`` that is installed under
``.\NixOS``. ``nixos-wsl-installer.tar.gz`` is the path to the file you
downloaded earlier. You might need to change this path or change to the download
directory first.

You can now run NixOS::

   wsl -d NixOS

The installer will unpack the file system and subsequently start NixOS.
A few warnings about file systems and locales will pop up. You can safely ignore them.
After systemd has started, you should be greeted with a bash prompt inside your fresh NixOS.

If you want to make NixOS your default distribution, you can do so via ``wsl -s
NixOS``.


systemd support
===============

WSL comes with its own (non-substitutable) init system while NixOS uses systemd.
Simply starting systemd later on does not work out of the box, because systemd
as system instance refuses to start if it is not PID 1. This unfortunate
combination is resolved in two ways:

* the user's default shell is replaced by a wrapper script that acts is init
  system and then drops to the actual shell
* systemd is started in its own PID namespace; therefore, it is PID 1. The shell
  wrapper (see above) enters the systemd namespace before dropping to the shell.


Installer
=========

Usually WSL distributions ship as a tarball of their root file system.
These tarballs however, can not contain any hard-links due to the way they are unpacked by WSL, resulting in an "Unspecified Error".
By default some Nix-derivations will contain hard-links when they are built. This results in system tarballs that can not be imported into WSL.
To circumvent this problem, the rootfs tarball is wrapped in that of a minimal distribution (the installer), that is packaged without any hard-links.
When the installer system is started for the first time, it overwrites itself with the contents of the rootfs tarball.


Build your own system tarball
=============================

This requires access to a system that already has Nix installed. Please refer to
the `Nix installation guide <https://nixos.org/guides/install-nix.html>`_ if
that's not the case.

If you have a flakes-enabled Nix, you can use the following command to build your
own tarball instead of relying on a prebuilt one::

   nix build github:nix-community/NixOS-WSL#nixosConfigurations.mysystem.config.system.build.installer

Or, if you want to build with local changes, run inside your checkout::

   nix build .#nixosConfigurations.mysystem.config.system.build.installer

Without a flakes-enabled Nix, you can build a tarball using::

   nix-build -A nixosConfigurations.mysystem.config.system.build.installer

The resulting mini rootfs can then be found under
``./result/tarball/nixos-wsl-installer.tar.gz``.

You can also build a rootfs tarball without wrapping it in the installer by replacing ``installer`` with ``tarball`` in the above commands.
The rootfs tarball can then be found under ``./result/tarball/nixos-wsl-x86_64-linux.tar.gz``.


License
=======

Apache License, Version 2.0. See ``LICENSE`` or
http://www.apache.org/licenses/LICENSE-2.0.html for details.


Further links
=============

* DistroLauncher_
* `A quick way into a systemd "bottle" for WSL <https://github.com/arkane-systems/genie>`_
* `NixOS in Windows Store for Windows Subsystem for Linux <https://github.com/NixOS/nixpkgs/issues/30391>`_
* `wsl2-hacks <https://github.com/shayne/wsl2-hacks>`_


.. _DistroLauncher: https://github.com/microsoft/WSL-DistroLauncher
