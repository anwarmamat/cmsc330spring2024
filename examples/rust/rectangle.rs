// struct

use std::fmt::Formatter;
use std::fmt::{Display, Result};

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn new(w: u32, h: u32,nm:String) -> Rectangle {
        Rectangle {
            width: w,
            height: h,
            name: nm
        }
    }
}

#[derive(Debug, PartialEq,Eq)]
struct Rectangle {
    width: u32,
    height: u32,
    name: String,
}

impl Display for Rectangle {
    fn fmt(&self, f: &mut Formatter) -> Result {
        write!(
            f,
            "Rectangle Width:{},Height:{},Name:{}",
            self.width, self.height, self.name
        )
    }
}
//impl Copy for Rectangle{}

impl Clone for Rectangle {
    fn clone(&self) -> Rectangle {
        Rectangle {
            width: self.width,
            height: self.height,
            name: self.name.clone(),
        }
    }
}

fn main() {
    let r1 = Rectangle {
        width: 10,
        height: 20,
        name: "hello".to_string(),
    };
    println!("{}",r1);
    let r2 = Rectangle::new(30,40, "rectangle".to_string());
    let r3 = r2.clone();
    let area = r2.area();
    println!("Area of r2={}",area);
    println!("{}",r3);
    assert! (r2 == r3);
}
