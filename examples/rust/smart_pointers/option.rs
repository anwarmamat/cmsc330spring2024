

fn div(x: f64, y: f64) -> Option<f64> {
    if y == 0.0 {
        None
    } else {
        Some(x / y)
    }
}

fn main() {
    let r = div(10.0, 3.0);
    match r {
        None => println!("Error"),
        Some(v) => println!("{v}"),
    };
}
