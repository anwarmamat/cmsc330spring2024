use std::cell::RefCell;

fn main() {
    let x = RefCell::new(5);

    //To get a mutable reference to your type, you use borrow_mut on the RefCell.
    {
        let mut y = x.borrow_mut();
        *y = 45;
    }
    let m = x.borrow();
    //borrow check at runtime
    let m = x.borrow_mut(); //panic at runtime. Already borrowed.

    println!("x={:?}", m);
    println!("x={:?}", x);
   
}
