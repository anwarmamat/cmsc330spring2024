
#[derive(Debug)]
enum Error {
    DivisionByZero,
}

fn div(x: f64, y: f64) -> Result<f64, Error> {
    if y == 0.0 {
        Err(Error::DivisionByZero)
    } else {
    Ok(x / y)
    }
}

fn main() {
    let r = div(10.0, 0.0);
    match r {
        Err(e) => println!("{:?}",e),
        Ok(v) => println!("{v}"),
    };
}
