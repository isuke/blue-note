namespace :notes do
  desc "Enumerate all annotations"
  task 'all' do
    SourceAnnotationExtractor.enumerate "OPTIMIZE|FIXME|TODO|HACK", tag: true
  end
end
