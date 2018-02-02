# add context to minitest
Minitest::Spec::DSL.send(:alias_method, :context, :describe)

# call block if the key is not found
thing.fetch(:non_existing_key) { perform your work here if the key is missing }
