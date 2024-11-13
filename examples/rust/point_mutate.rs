#[derive(Debug)]
struct Point {
  x: i32,
  y: i32,
}
impl Point {
    fn m(&mut self) {
        self.x += 1;
        self.y += 1;
    }
}
fn main(){
    let mut p = Point{ x: 0, y: 0 };
    println!("Before: {:?}",p);
    p.m();
    println!("After: {:?}",p);
}
