use std::cell::RefCell;
use std::rc::Rc;

#[derive(Debug)]
enum List {
    Cons(Rc<RefCell<String>>, Rc<List>),
    Nil,
}

use List::{Cons, Nil};


fn baz() {
    let val = Rc::new(RefCell::new(String::from("java")));
    let a = Rc::new(Cons(Rc::clone(&val), Rc::new(Nil)));
    let b = Cons(Rc::new(RefCell::new(String::from("C"))), Rc::clone(&a));
    let c = Cons(Rc::new(RefCell::new(String::from("C++"))), Rc::clone(&a));
    *val.borrow_mut() = String::from("C#");
    println!("a: {:?}", a);
    println!("b: {:?}", b);
    println!("c: {:?}", c);
}

fn main() {
  baz();
}
