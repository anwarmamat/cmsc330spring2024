use std::cell::RefCell;
use std::rc::Rc;
#[derive(Debug)]
enum List {
    Cons(Rc<RefCell<String>>, Rc<List>),
    Nil,
}

use List::{Cons, Nil};
fn foo() {
    let a = RefCell::new(15);
    let b = a.borrow();
    let c = a.borrow();
    println!("Value of b is : {}", b);
    println!("Value of c is : {}", c);
}

fn main() {
    foo();
}
