use std::cell::Cell;
#[derive(Debug)]
struct Point<'a> {
    x: i32,
    y: i32,
    color: Cell<&'a str>,
}

fn main() {
    let p1 = Point {
        x: 10,
        y: 20,
        color: Cell::new("red"),
    };

    // ERROR: `p1` is immutable
    //p1.x = 99;

    println!("{:?}",p1);

    // WORKS: although `p1` is immutable, `color` is a `Cell`,
    // which can always be mutated
    let t = p1.color.get();
    p1.color.set("blue");
    println!("{:?}",p1);

    //println!("{:?}", p1.color.get());
    
}
