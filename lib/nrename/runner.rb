module Nrename
  class Runner
    def self.run(args)
      Nrename.set_options_from args

      dirs = Nrename.options.dirs.map { |dir| Directory.new dir }
      if dirs.all? &:empty?
        warn 'No matched files to rename.'
      else
        dirs.each &:normalize
      end
    end
  end
end
