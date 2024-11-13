// Define a trait Printable
trait Printable {
    fn print(&self);
}

// Define a struct to implement a trait
struct Person {
    name: String,
    age: u32,
}

impl Printable for u32{
    fn print(&self) {
        println!("{{Hello}}",x);
    } 
}
// Implement trait Printable on struct Person
impl Printable for Person {
    fn print(&self) {
        println!("Person {{ name: {}, age: {} }}", self.name, self.age);
    }
}

// Define another struct to implement a trait
struct Car {
    make: String,
    model: String,
}

// Define trait Printable on struct Car
impl Printable for Car {
    fn print(&self) {
        println!("Car {{ make: {}, model: {} }}", self.make, self.model);
    }
}

// Utility function to print any object that implements the Printable trait
fn print_thing<T: Printable>(thing: &T) {
    thing.print();
}

fn main() {
    // Instantiate Person and Car
    let person = Person { name: "Hari".to_string(), age: 31 };
    let car = Car { make: "Tesla".to_string(), model: "Model X".to_string() };
    
    // Call print_thing with reference of Person and Car
    print_thing(&person);
    print_thing(&car);
    1.print();
}