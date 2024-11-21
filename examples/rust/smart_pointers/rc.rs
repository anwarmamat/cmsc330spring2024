#[derive(Debug)]
enum List {
    Cons(i32, Rc<List>),
    Nil,
}

use std::rc::Rc;
use List::{Cons, Nil};
fn main() {
    let a = Rc::new(Cons(5, Rc::new(Cons(10, Rc::new(Nil)))));
    let b = Cons(3, Rc::clone(&a));
    {
        let c = Cons(4, Rc::clone(&a)); //ok
        println!("a:{:?}", a);
        println!("b:{:?}", b);
        println!("c:{:?}", c);
        println!("a ref count: {}", Rc::strong_count(&a));
    }
    println!("a ref count: {}", Rc::strong_count(&a));
}
