
// Import required zkwasm sdk items here
use zkwasm_rust_sdk::{dbg, wasm_input, wasm_read_context, wasm_write_context};

use wasm_bindgen::prelude::*;

// #[wasm_bindgen]
pub fn zkmain() -> i64 {
    let input_pub_1 = unsafe { wasm_input(1) };
    let input_pub_2 = unsafe { wasm_input(1) };

    let prev_context = unsafe { wasm_read_context() };
    
    let new_context = prev_context + input_pub_1 * input_pub_2;
    dbg!("new ctx is {:?}...\n", new_context);
    unsafe { wasm_write_context(new_context) };
    0
}
