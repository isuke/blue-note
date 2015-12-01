Vue.modules.filterable = {
  data: ->
    query: {} # please override if you want
    schema: {}   # please override
  computed:
    queryStr:
      get: ->
        temp = ''
        $.each @query, (key, vals) =>
          temp += "#{key}:#{vals.join(',')} "
        temp
      set: (queryStr) ->
        result = {}
        $.each queryStr.replace(/(^\s+)|(\s+$)/g, '').split(/\s+/), (i, q) =>
          kv = q.split(':')
          key    = kv[0]
          values = kv[1]
          if values?
            result[key] = []
            $.each values.split(/\s*,\s*/), (i, v) =>
              result[key].push v
        @query = result
  methods:
    filter: (list, query = @query, schema = @schema) ->
      _.filter list, (item) =>
        _.all query, (vals, k) =>
          _.any vals, (val) =>
            switch schema[k]
              when 'eq'   then return item[k] == val
              when 'like' then return (new RegExp(val, 'i')).test item[k]
              when 'int'
                sn = /(>=|>|<=|<|=)?([0-9]*)/.exec val
                sign = sn[1] || '='
                v  = if sn[2] != '' then parseInt(sn[2], 10) else null
                switch sign
                  when '='  then return item[k] == v
                  when '>=' then return item[k] >= v
                  when '>'  then return item[k] >  v
                  when '<=' then return item[k] <= v
                  when '<'  then return item[k] <  v
              else true
}
