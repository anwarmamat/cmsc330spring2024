trait Printable {
    fn stringify(&self) -> String;
}
impl Printable for i32 {
    fn stringify(&self) -> String {
        self.to_string()
    }
}

struct Point {
    x: i32,
    y: i32,
}
impl Printable for Point {
    fn stringify(&self) -> String {
        format!("Point: x:{},y:{}", self.x, self.y)
    }
}

fn main() {
    println!("{}", 1.stringify());
    let p1 = Point { x: 10, y: 20 };
    println!("{}", p1.stringify());
}
