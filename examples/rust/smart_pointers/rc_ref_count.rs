use std::rc::Rc;
fn print_refcount(r: &Rc<i32>) {
    println!("{}", Rc::strong_count(&r));
}

fn main() {
    let forty_two = Rc::new(42);
    print_refcount(&forty_two);
    {
        let v = Rc::clone(&forty_two);
        print_refcount(&v); // What does this print?
    }
}
