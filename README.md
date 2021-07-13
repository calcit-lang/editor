
Calcit Editor
------

> Intuitive S-expressions editing for Calcit.

* **Auto Layout**: expressions in blocks and inline-blocks, styled with CSS
* **Tree Editing**: intuitive way of structural editing as nested expressions
* **Call Stack Navigation**: more fine-grained functions navigation
* **Collaboration**: changes real-time synced among multiple clients via WebSockets

One function/definition in a screen, `Command d` to open called function at next tab, `Command j` `Command k` `Command i` to switch:

![Expression editor](https://pbs.twimg.com/media/ES6_JjPU4AEJ7zt?format=png&name=large)

Based on DOM/CSS, easy for another theme:

![Styling](https://pbs.twimg.com/media/ES6_PiQU4AM0ceN?format=png&name=large)

`Command p` to search and jump inspired by Sublime Text :

![Search panel](https://pbs.twimg.com/media/ES68XGoUwAAzudc?format=png&name=large)

Browse namespaces and functions/variables:

![Definitions browser](https://pbs.twimg.com/media/ES68ScLUEAAiW3Z?format=png&name=large)

### Usages

![npm CLI of @calcit/editor](https://img.shields.io/npm/v/@calcit/editor.svg)

Install CLI and start a local WebSocket server, it uses `calcit.cirru` as a snapshot file:

```bash
npm i -g @calcit/editor
ct
```

UI of the editor is a webapp on http://editor.calcit-lang.org/?port=6001

You may try with my project templates:

* simple virtual DOM playground [calcit-workflow](https://github.com/mvc-works/calcit-workflow)
* a toy Node.js script [calcit-nodejs-workflow](https://github.com/mvc-works/calcit-nodejs-workflow)

or even clone current repo for trying out.

Don't forget to check out [keyboard shortcuts](https://github.com/Cirru/calcit-editor/wiki/Keyboard-Shortcuts). My old [introduction videos](https://www.youtube.com/watch?v=u5Eb_6KYGsA&t) can be found on YouTube.

### Options

CLI variables for compiling code directly from `calcit.cirru`:

```bash
op=compile ct
```

The web UI takes several query options:

```
http://editor.calcit-lang.org/?host=localhost&port=6001
```

* `port`, defaults to `6001`
* `host`, defaults to `localhost`, connects via WebSocket

Code is emitted in `compact.cirru` by pressing `Command s`. Two extra files will be emitted:

* `compact.cirru` contains a compact version of data tree of the program.
* `.compact-inc.cirru` contains diff information from latest modification of per definition.

It would be used in [calcit-runner](https://github.com/calcit-lang/calcit_runner.rs).

When server is stopped with `Control c`, `calcit.cirru` is also updated.

There are also several options in `:configs` field in `calcit.cirru`:

* `port`, defaults to `6001`

Editor UI is decoupled with WebSocket server, so it's okay to connect remote server from multiple pages with all expressions synced in real-time.

### Workflow

Previously it's https://github.com/Cirru/calcit-editor which is for ClojureScript. And this repo is for Calcit-js only.

### License

MIT
