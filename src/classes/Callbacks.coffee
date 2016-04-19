class Callbacks
  @Post          = new Callbacks 'Post'
  @Thread        = new Callbacks 'Thread'
  @CatalogThread = new Callbacks 'Catalog Thread'

  constructor: (@type) ->
    @keys = []

  push: ({name, cb}) ->
    @keys.push name unless @[name]
    @[name] = cb

  execute: (node, keys=@keys) ->
    for name in keys
      try
        @[name]?.call node
      catch err
        errors = [] unless errors
        errors.push
          message: ['"', name, '" crashed on node ', @type, ' No.', node.ID, ' (', node.board, ').'].join('')
          error: err

    Main.handleErrors errors if errors

return Callbacks
