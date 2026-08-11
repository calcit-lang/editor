# Remove the obsolete lilac module dependency

- Removed `lilac/` from both the `default` and `client` entry module lists.
- The editor snapshot no longer contains any `lilac` namespace or definition reference; the module was a stale configuration-only dependency.
- Confirmed the default/server entry loads without lilac and passes `cr calcit.cirru --check-only`. The client entry also loads without the missing module; its existing application warnings remain a separate migration task.
