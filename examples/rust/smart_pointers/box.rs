#[derive(Debug)]

enum List {
    Nil,
    Cons(u32, Box<List>),
}

// let list = Cons(1, Box::new(Nil));
// let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));

use List::{Cons, Nil};
impl List {
    fn len(&self) -> u32 {
        match self {
            Nil => 0,
            Cons(_x, t) => 1 + t.len(),
        }
    }
    fn sum(&self) -> u32 {
        match self {
            Nil => 0,
            Cons(h, t) => h + t.sum(),
        }
    }
}

fn sum2(lst: &List) -> u32 {
    match lst {
        Nil => 0,
        Cons(v, t) => v + sum2(t),
    }
}

fn main() {
    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));
    println!("{:?}, \nlen={}", list, list.len());
    println!("sum={}", list.sum());
    println!("sum={}", sum2(&list));
}
