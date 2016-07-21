# add context to minitest
Minitest::Spec::DSL.send(:alias_method, :context, :describe)
