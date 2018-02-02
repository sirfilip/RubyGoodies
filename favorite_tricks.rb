# add context to minitest
Minitest::Spec::DSL.send(:alias_method, :context, :describe)

# call block if the key is not found
thing.fetch(:non_existing_key) { perform your work here if the key is missing }
# also always use fetch and receive a KeyError if key is not found
thing.fetch(:non_existing_key) # will raise KeyError 
