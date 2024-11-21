use std::cell::Cell;
#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
    color: Cell<u32>,
}

fn main() {
    let p1 = Point {
        x: 10,
        y: 20,
        color: Cell::new(88),
    };

    // ERROR: `p1` is immutable
    //p1.x = 99;

    println!("{:?}",p1);

    // WORKS: although `p1` is immutable, `color` is a `Cell`,
    // which can always be mutated
    let p2 = &p1;
   p2.color.set(99);
    println!("{:?}",p1);

    //println!("{:?}", p1.color.get());
    
}
