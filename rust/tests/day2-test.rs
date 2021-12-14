#![allow(overflowing_literals)]
use std::convert::From;

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32
}

fn main() {
    // before 7
    // after 50
    // outer 7
    let _mutable_integer = 7i32;
    {
        println!("before {}", _mutable_integer);
        let _mutable_integer = _mutable_integer;
        _mutable_integer = 50;
        println!("after {}", _mutable_integer);
    }
    println!("outer {}", _mutable_integer);
    
    // The Point is Point { x: 30, y: 30 }
    let point = Point::from(30);
    println!("The Point is {:?}", point);

    // x as a u8 is : 132
    println!("x as a u8 is : {}", /* x */ as u8);
}
