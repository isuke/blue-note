Vue.filter 'paginate', (list) ->
  s = parseInt(@$get('pageStart'), 10)
  e = parseInt(@$get('pageEnd')  , 10)
  return list.slice(s, e + 1)

Vue.modules.paginationable = {
  data: ->
    currentPage: 0
    pageSize: 10 # please override if you want
  computed:
    listLength: -> 0 # please override
    pageTotal:  -> Math.ceil(@listLength / @pageSize)
    pageStart:  -> (@currentPage - 1) * @pageSize
    pageEnd:    -> (@currentPage * @pageSize) - 1
  methods:
    setCurrentPage: (val) ->
      @currentPage = val if 0 < val and val <= @pageTotal
    firstPage: -> @setCurrentPage(1)
    lastPage:  -> @setCurrentPage(@pageTotal)
    prevPage:  -> @setCurrentPage(@currentPage - 1)
    nextPage:  -> @setCurrentPage(@currentPage + 1)
  watch:
    pageSize:   -> @currentPage = @pageTotal if @pageTotal < @currentPage
    listLength: -> @currentPage = @pageTotal if @pageTotal < @currentPage
}
