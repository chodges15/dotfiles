This is my home directory and holds my dotfiles. Here are some instructions on how to use:

1. I am using a tool called dotbot to manage and source control my dotfiles. It uses symlinks, and you can find the targets of those symlinks under ~/src/dotfiles.

2. The configuration for this tool is located in ~/src/dotfiles/install.conf.yaml
3. To apply the configuration you can run ~/src/dotfiles/install

** Configuration Syntax **
## Configuration

Dotbot uses YAML or JSON-formatted configuration files to let you specify how to set up your dotfiles. Currently, Dotbot knows how to [link](#link) files and folders, [create](#create) folders, execute [shell](#shell) commands, and [clean](#clean) directories of broken symbolic links. Dotbot also supports user [plugins](#plugins) for custom commands.

**Ideally, bootstrap configurations should be idempotent. That is, the installer should be able to be run multiple times without causing any problems.** This makes a lot of things easier to do (in particular, syncing updates between machines becomes really easy).

Dotbot configuration files are arrays of tasks, where each task is a dictionary that contains a command name mapping to data for that command. Tasks are run in the order in which they are specified. Commands within a task do not have a defined ordering.

When writing nested constructs, keep in mind that YAML is whitespace-sensitive. Following the formatting used in the examples is a good idea. If a YAML configuration file is not behaving as you expect, try inspecting the [equivalent JSON][json2yaml] and check that it is correct.

## Directives

Most Dotbot commands support both a simplified and extended syntax, and they can also be configured via setting [defaults](#defaults).

### Link

Link commands create symbolic links at specified locations that point to files in your dotfiles repository. This allows you to keep your configuration files in version control while having them appear where applications expect to find them. Symlinks are created by default, but hardlinks are also supported. If desired, items can be specified to be forcibly linked, overwriting existing files if necessary. Environment variables in paths are automatically expanded.

#### Format

Link commands are specified as a dictionary mapping link names to targets. The link name (key) is where the symbolic link will be created, and the target (value) is the file in your dotfiles directory that the link will point to. Targets are specified relative to the base directory (that is specified when running the installer). If linking directories, *do not* include a trailing slash.

Link commands support an optional extended configuration. In this type of configuration, instead of specifying targets directly, link names are mapped to extended configuration dictionaries.

| Parameter | Explanation |
| --- | --- |
| `path` | The target for the link (file in dotfiles directory), the same as in the shortcut syntax (default: null, automatic (see below)) |
| `type` | The type of link to create. If specified, must be either `symlink` or `hardlink`. (default: `symlink`) |
| `create` | When true, create parent directories to the link as needed. (default: false) |
| `relink` | Removes the old link if it's a symlink (default: false) |
| `force` | Force removes the old link, file or folder, and forces a new link (default: false) |
| `relative` | When creating a symlink, use a relative path to the target. (default: false, absolute links) |
| `canonicalize` | Resolve any symbolic links encountered in the target to symlink to the canonical path (default: true, real paths) |
| `if` | Execute this in your `$SHELL` and only link if it is successful. |
| `ignore-missing` | Do not fail if the target is missing and create the link anyway (default: false) |
| `glob` | Treat `path` as a glob pattern, expanding patterns referenced below, linking all *files* matched. (default: false) |
| `exclude` | Array of glob patterns to remove from glob matches. Uses same syntax as `path`. Ignored if `glob` is `false`. (default: empty, keep all matches) |
| `prefix` | Prepend prefix prefix to basename of each file when linked, when `glob` is `true`. (default: '') |

When `glob: true`, Dotbot uses [glob.glob](https://docs.python.org/3/library/glob.html#glob.glob) to resolve glob paths, expanding Unix shell-style wildcards, which are **not** the same as regular expressions; Only the following are expanded:

| Pattern  | Meaning                            |
|:---------|:-----------------------------------|
| `*`      | matches anything                   |
| `**`     | matches any **file**, recursively  |
| `?`      | matches any single character       |
| `[seq]`  | matches any character in `seq`     |
| `[!seq]` | matches any character not in `seq` |

However, due to the design of `glob.glob`, using a glob pattern such as `config/*`, will **not** match items that begin with `.`. To specifically capture items that being with `.`, you will need to include the `.` in the pattern, like this: `config/.*`.

When using glob with the `exclude:` option, the paths in the exclude paths should be relative to the base directory, same as the glob pattern itself. For example, if a glob pattern `vim/*` matches directories `vim/autoload`, `vim/ftdetect`, `vim/ftplugin`, and `vim/spell`, and you want to ignore the spell directory, then you should use `exclude: ["vim/spell"]` (not just `"spell"`).

#### Example

```yaml
- link:
    ~/.config/terminator:
      create: true
      path: config/terminator
    ~/.vim: vim
    ~/.vimrc:
      relink: true
      path: vimrc
    ~/.zshrc:
      force: true
      path: zshrc
    ~/.hammerspoon:
      if: '[ `uname` = Darwin ]'
      path: hammerspoon
    ~/.config/:
      glob: true
      path: dotconf/config/**
    ~/:
      glob: true
      path: dotconf/*
      prefix: '.'
```

If the target location is omitted or set to `null`, Dotbot will use the basename of the link name, with a leading `.` stripped if present. This makes the following two config files equivalent.

Explicit targets:

```yaml
- link:
    ~/bin/ack: ack
    ~/.vim: vim
    ~/.vimrc:
      relink: true
      path: vimrc
    ~/.zshrc:
      force: true
      path: zshrc
    ~/.config/:
      glob: true
      path: config/*
      relink: true
      exclude: [ config/Code ]
    ~/.config/Code/User/:
      create: true
      glob: true
      path: config/Code/User/*
      relink: true
```

Implicit targets:

```yaml
- link:
    ~/bin/ack:
    ~/.vim:
    ~/.vimrc:
      relink: true
    ~/.zshrc:
      force: true
    ~/.config/:
      glob: true
      path: config/*
      relink: true
      exclude: [ config/Code ]
    ~/.config/Code/User/:
      create: true
      glob: true
      path: config/Code/User/*
      relink: true
```

### Create

Create commands specify empty directories to be created.  This can be useful for scaffolding out folders or parent folder structure required for various apps, plugins, shell commands, etc.

#### Format

Create commands are specified as an array of directories to be created. If you want to use the optional extended configuration, create commands are specified as dictionaries. For convenience, it's permissible to leave the options blank (null) in the dictionary syntax.

| Parameter | Explanation |
| --- | --- |
| `mode` | The file mode to use for creating the leaf directory (default: 0777) |

The `mode` parameter is treated in the same way as in Python's [os.mkdir](https://docs.python.org/3/library/os.html#mkdir-modebits). Its behavior is platform-dependent. On Unix systems, the current umask value is first masked out.

#### Example

```yaml
- create:
    - ~/downloads
    - ~/.vim/undo-history
- create:
    ~/.ssh:
      mode: 0700
    ~/projects:
```

### Shell

Shell commands specify shell commands to be run. Shell commands are run in the base directory (that is specified when running the installer).

#### Format

Shell commands can be specified in several different ways. The simplest way is just to specify a command as a string containing the command to be run.

Another way is to specify a two element array where the first element is the shell command and the second is an optional human-readable description.

Shell commands support an extended syntax as well, which provides more fine-grained control.

| Parameter | Explanation |
| --- | --- |
| `command` | The command to be run |
| `description` | A human-readable message describing the command (default: null) |
| `quiet` | Show only the description but not the command in log output (default: false) |
| `stdin` | Allow a command to read from standard input (default: false) |
| `stdout` | Show a command's output from stdout (default: false) |
| `stderr` | Show a command's error output from stderr (default: false) |

Note that `quiet` controls whether the command (a string) is printed in log output, it does not control whether the output from running the command is printed (that is controlled by `stdout` / `stderr`). When a command's `stdin` / `stdout` / `stderr` is not enabled (which is the default), it's connected to `/dev/null`, disabling input and hiding output.

#### Example

```yaml
- shell:
  - chsh -s $(which zsh)
  - [chsh -s $(which zsh), Making zsh the default shell]
  -
    command: read var && echo Your variable is $var
    stdin: true
    stdout: true
    description: Reading and printing variable
    quiet: true
  -
    command: read fail
    stderr: true
```

### Clean

Clean commands specify directories that should be checked for dead symbolic links. These dead links are removed automatically. Only dead links that point to somewhere within the dotfiles directory are removed unless the `force` option is set to `true`.

#### Format

Clean commands are specified as an array of directories to be cleaned.

Clean commands also support an extended configuration syntax.

| Parameter | Explanation |
| --- | --- |
| `force` | Remove dead links even if they don't point to a file inside the dotfiles directory (default: false) |
| `recursive` | Traverse the directory recursively looking for dead links (default: false) |

Note: using the `recursive` option for `~` is not recommended because it will be slow.

#### Example

```yaml
- clean: ['~']

- clean:
    ~/:
      force: true
    ~/.config:
      recursive: true
```
## Command-line arguments (for install script)

Dotbot takes a number of command-line arguments; you can run Dotbot with `--help`, for example, by running `./install --help`, to see the full list of options. Here, we highlight a couple that are particularly interesting.

### `--dry-run`

You can call `./install --dry-run`, and Dotbot will explain what it _would_ do, without actually making any changes. This can be helpful for safely testing your configuration. Plugins that don't support dry-run will be skipped.

### `--only`

You can call `./install --only [list of directives]`, such as `./install --only link`, and Dotbot will only run those sections of the config file.

### `--except`

You can call `./install --except [list of directives]`, such as `./install --except shell`, and Dotbot will run all the sections of the config file except the ones listed.
