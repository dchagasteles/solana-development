use std::fmt; // Import the `fmt` module.

struct Color {
    red: u8,
    green: u8,
    blue: u8,
}

impl fmt::Display for Color {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // TODO:
    }
}

struct Matrix(f32, f32, f32, f32);

impl fmt::Display for Matrix {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // TODO:
    }
}

fn transpose(matrix: Matrix) -> Matrix {
    // TODO:
}

struct Point {
    x: i32,
    y: i32,
}

struct Rectangle {
    top_left: Point,
    bottom_right: Point,
}

impl Rectangle {
    fn area(&self) -> i32 {
        let /* TODO: */ = self.top_left;
        let /* TODO: */ = self.bottom_right;
        (right_edge-left_edge) * (bottom_edge-top_edge)
    }
}

fn main() {
    // RGB (128, 255, 90) 0x80FF5A
    // RGB (0, 3, 254) 0x0003FE
    // RGB (0, 0, 0) 0x000000
    for color in [
        Color { red: 128, green: 255, blue: 90 },
        Color { red: 0, green: 3, blue: 254 },
        Color { red: 0, green: 0, blue: 0 },
    ].iter() {
        println!("{:}", *color);
    }

    // Matrix:
    // ( 1.1 1.2 )
    // ( 2.1 2.2 )
    // Transpose:
    // ( 1.1 2.1 )
    // ( 1.2 2.2 )
    let matrix = Matrix(1.1, 1.2, 2.1, 2.2);
    println!("Matrix:\n{}", matrix);
    println!("Transpose:\n{}", transpose(matrix));
    // Rect Area: 1
    println!("Rect Area: {}", Rectangle{top_left: Point{x:1, y:1}, bottom_right: Point{x:2, y:2}}.area());
}
