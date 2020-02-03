# Alluvion

```
Commands:
  alluvion help [COMMAND]  # Describe available commands or one specific command
  alluvion synchro:down    # Execute synchro (down)
  alluvion synchro:up      # Execute synchro (up)
```

## Requirements

Alluvion uses ``rsync`` (as default) to synchronize files.

## Config

### Minimal configuration

```yaml
url: 'ssh://user@example.org:22'
paths:
  local:
    done: '/tmp/alluvion/complete'
    todo: '/home/dimitri/Desktop/alluvion/spec/samples/files'
  remote:
    done: '/var/torrents/complete'
    todo: '/tmp/todo'
```

### Environment

Config supports environment variables, using ERB-like syntax:

```yaml
url: 'ssh://<%= @SYNCHRO_USER%>@<%= @SYNCHRO_HOST%>:22'
timeout: <%= @SYNCHRO_TIMEOUT || 5 %>
paths:
  local:
    done: '<%= @SYNCHRO_VOLUME %>/done'
    todo: '<%= @SYNCHRO_VOLUME %>/todo'
  remote:
    done: '<%= @SYNCHRO_REMOTE_PATH %>/done'
    todo: '<%= @SYNCHRO_REMOTE_PATH %>/done'
```
