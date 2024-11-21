trait Format {
    fn to_s(&self) -> String;
}

impl Format for u8 {
    fn to_s(&self) -> String { format!("u8: {}", *self) }
}

impl Format for String {
    fn to_s(&self) -> String { format!("string: {}", *self) }
}

fn do_something<T: Format>(x: T) {
     x.method();
}

fn print2(x: Box<dyn Format>) {
    println!("{}",x.to_s());
}

fn main() {
    let x = 5u8;
    let y = "Hello".to_string();

    print2(Box::new(x));
    print2(Box::new(y));
}
