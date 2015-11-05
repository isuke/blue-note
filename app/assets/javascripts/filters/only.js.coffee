Vue.filter 'only', (list, exists_or_not_exits, delimiter, key) ->
  _.filter list, (item) ->
    if exists_or_not_exits == 'exists'
      return item[key] != null
    else
      return item[key] == null
