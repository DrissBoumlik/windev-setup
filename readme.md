# Windows Development Environment Setup

## Overview
This tool allows you to automate the setup of your development environment in windows, including PHP, NVM, and essential terminal utilities..

## Features
- Installs development tools: Notepad++, Composer, Git, NVM (Node Version Manager) ...

- Terminal Utilities: fzf (Fuzzy Finder), zoxide (Smart CD Command)...

- Terminal Enhancements: Configures Cmder with custom theme, Installs Nerd Fonts ...

- PHP Development Setup: Installs multiple PHP versions & Configures Xdebug for installed PHP versions

## Prerequisites
* Administrator rights in Windows PowerShell
* Stable internet connection

## Quick Start

### Preparation
1. Open `Windows PowerShell` as Administrator
2. Set execution policy:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```

### Installation
1. Run initial setup:
   ```powershell
   .\setup.ps1
   ```
2. Review execution results
3. Run follow-up script:
   ```powershell
   .\followup.ps1
   ```

## Requirements
- Windows 10/11
- PowerShell 5.1 or later

## Troubleshooting
- Ensure all prerequisites are met
- Check PowerShell execution policy
- Verify internet connectivity


