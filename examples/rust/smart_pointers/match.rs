
enum Number {
    Zero,
    One,
    Two,
}

use Number::Zero;
fn main(){
   let t = Number::One;
   match t {
   	 Zero=> println!("0"),
	   Number::One => println!("1"),
	 }
}
