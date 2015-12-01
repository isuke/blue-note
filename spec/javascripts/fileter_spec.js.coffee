describe 'filterable', ->
  filterable = Vue.modules.filterable

  # HACK
  describe '#filter', ->
    it 'should have a filter function', ->
      expect(typeof filterable.methods.filter).toBe('function')
    describe 'when eq query', ->
      it 'should filter list by eq', ->
        query = {item: ['todo', 'doing']}
        schema = {item: 'eq'}
        list = [
          {item: 'todo' , other: 'hoge'},
          {item: 'doing', other: 'hoge'},
          {item: 'done' , other: 'todo'},
        ]
        expected_result = [
          {item: 'todo' , other: 'hoge'},
          {item: 'doing', other: 'hoge'},
        ]
        expect(filterable.methods.filter(list, query, schema)).toEqual expected_result
    describe 'when like query', ->
      it 'should filter list by like', ->
        query = {item: ['todo', 'doing']}
        schema = {item: 'like'}
        list = [
          {item: 'it is todo item.' , other: 'hoge'},
          {item: 'I doing it.'      , other: 'hoge'},
          {item: 'that done!'       , other: 'todo'},
        ]
        expected_result = [
          {item: 'it is todo item.' , other: 'hoge'},
          {item: 'I doing it.'      , other: 'hoge'},
        ]
        expect(filterable.methods.filter(list, query, schema)).toEqual expected_result
    describe 'when int query', ->
      it 'should filter list by int', ->
        query = {item: ['=0']}
        schema = {item: 'int'}
        list = [
          {item: 0    , other: 1},
          {item: 1    , other: 0},
          {item: 2    , other: 0},
          {item: null , other: 0},
        ]
        expected_result = [
          {item: 0 , other: 1}
        ]
        expect(filterable.methods.filter(list, query, schema)).toEqual expected_result
