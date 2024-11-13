struct Point<T> {
  x: T,
  y: T,
}

impl<T> Point<T> { 
  fn x(&self) -> &T {
    &self.x
  }
}

fn main() {
  let p = Point { x:5, y:10};
    println!("p.x = {}", p.x());
    println!("p.y = {}", p.y);
  let p2 = Point { x:"A", y:"B"};
    println!("p2.x = {}", p2.x());
    println!("p2.y = {}", p2.y);

}

