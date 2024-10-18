use std::fmt; // Import the `fmt` module.

struct Color {
    red: u8,
    green: u8,
    blue: u8,
}

impl fmt::Display for Color {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "RGB ({0}, {1}, {2}) 0x{0:0>2X}{1:0>2X}{2:0>2X}", self.red, self.green, self.blue)
    }
}

struct Matrix(f32, f32, f32, f32);

impl fmt::Display for Matrix {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "( {} {} )\n( {} {} )", self.0, self.2, self.1, self.3)
    }
}

fn transpose(matrix: Matrix) -> Matrix {
    return Matrix(matrix.0, matrix.3, matrix.1, matrix.2)
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
        let Point { x: left_edge, y: top_edge } = self.top_left;
        let Point { x: right_edge, y: bottom_edge } = self.bottom_right;
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
