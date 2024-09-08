import gleam/bit_array
import gleam/io
import gleam/list

pub fn main() {
  io.println("Hello from test_gleam!")
  io.println(bit_array.base64_encode(
    bit_array.from_string("Hello from test_gleam!"),
    True,
  ))
  io.debug(sum_int_list([1, 2, 3, 4]))
  io.debug(sum_and_square([1, 1, 1, 1]))
}

pub fn sum_int_list(list: List(Int)) {
  list.fold(list, 0, fn(a, b) { a + b })
}

@external(erlang, "Elixir.ElixirGleam.Func", "sum_and_square")
pub fn sum_and_square(list: List(Int)) -> Int
