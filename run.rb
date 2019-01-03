require './lib/factory.rb'
factory = Factory.new(:car, :model) do
  def hello
    "Wrum wrum #{car}!"
  end
end
test = factory.new('bmw', 7)

puts test[:car]
puts test.model
puts test['car']
puts test[1]

puts test.hello
