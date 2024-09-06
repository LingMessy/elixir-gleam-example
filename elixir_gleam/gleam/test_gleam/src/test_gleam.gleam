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
}

pub fn sum_int_list(list: List(Int)) {
  list.fold(list, 0, fn(a, b) { a + b })
}
