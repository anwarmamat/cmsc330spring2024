use std::cell::RefCell;

fn bar() {
    let a = RefCell::new(10);
    println!("{:?}",a.take());
    let b = a.borrow();
    //let mut c = a.borrow_mut(); // cause panic.
    println!("Value of b is : {}", b);
    //println!("Value of c is : {}",c);
    //*c = 100;
    //println!("{:?}",a.take());

fn main() {
    bar();

}
