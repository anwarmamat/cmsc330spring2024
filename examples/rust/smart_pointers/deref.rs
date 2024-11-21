fn hello(x: &str) {
    println!("hello {}", x);
}
fn main() {
    let m = Box::new(String::from("Rust"));
    hello(&m);
    println!("{}",m);
    hello(&(*m)[..]);
}
