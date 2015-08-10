Vue.modules.filterable = {
  data: ->
    queryStr: '' # please override if you want
    schema: {}   # please override
  computed:
    ###
    @param  {String} queyStr
    @param  {Object} schema
    @return {Object} query
    @example
      queryStr = 'item1:a,b,c item2:x,y,z, item3:>=1'
      schema = { item1:'enum', item2:'like', item3:'int' }
      return { item1:['a','b','c'], item2:['x','y','z'], item3:[['>=',1]] }
    ###
    # TODO implement 'OR' condition
    query: (queryStr = @queryStr, schema = @schema)->
      result = {}
      $.each queryStr.split(/\s+/), (i, q)=>
        kv = q.split(':')
        key    = kv[0]
        values = kv[1]
        if values?
          result[key] = []
          $.each values.split(/\s*,\s*/), (i, v)=>
            result[key].push @convert(key, v, schema)
      result
  methods:
    convert: (key, value, schema)->
      switch schema[key]
        when 'enum', 'like' then return value
        when 'int'
          sn = /(>=|>|<=|<|=)?([0-9]+)/.exec value
          sign = sn[1] || '='
          num  = parseInt(sn[2], 10)
          return [sign, num]
    filter: (list, query = @query, schema = @schema)->
      _.filter list, (item)=>
        _.all query, (values, k)=>
          _.any values, (v)=>
            switch schema[k]
              when 'enum' then return item[k] == v
              when 'like' then return (new RegExp(v, 'i')).test item[k]
              when 'int'
                switch v[0]
                  when '='  then return item[k] == v[1]
                  when '>=' then return item[k] >= v[1]
                  when '>'  then return item[k] >  v[1]
                  when '<=' then return item[k] <= v[1]
                  when '<'  then return item[k] <  v[1]
              else true
}
