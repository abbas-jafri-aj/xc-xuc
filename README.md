# dnf - A Simple `apt` Wrapper for Ubuntu/Debian

`dnf` is a Bash script that translates common `dnf` commands to `apt` on Ubuntu and Debian systems. It does **not** emulate `dnf`; it simply forwards supported commands and flags directly to `apt`.

## Features

- Supports basic `dnf` commands:
  - `install`
  - `remove` / `erase`
  - `update`
  - `upgrade`
  - `autoremove`
  - `list`
  - `info`
  - `search`
  - `clean`
- Minimal setup: just a script, no dependencies.
- Provides a simple `help` command.

## Usage

1. **Name the file** to `dnf` (not `dnf.sh`) to allow it to behave like the real `dnf` command.
2. **Make it executable**:

```bash
chmod +x dnf
```

3. **Place it in your `PATH`**:

   - Move it to a directory already in your `PATH` (e.g., `/usr/local/bin/`)  
     ```bash
     sudo mv dnf /usr/local/bin/
     ```
   - Or add the directory containing `dnf` to your `PATH`.

4. **Run commands as you would with `dnf`:**

```bash
dnf install package_name
dnf remove package_name
dnf update
dnf upgrade
dnf autoremove
dnf list
dnf info package_name
dnf search package_name
dnf clean
```

5. **Help command:**

```bash
dnf help
dnf --help
```

## Example

```bash
# Install git using dnf (actually uses apt under the hood)
dnf install git

# Remove a package
dnf remove vim

# Update package lists
dnf update

# Upgrade installed packages
dnf upgrade
```

## Notes

- This script is intended for users transitioning from `dnf` (Fedora/RHEL) to `apt` (Ubuntu/Debian).
- Unsupported or unknown commands will produce an error message and suggest using `dnf help`.

---
