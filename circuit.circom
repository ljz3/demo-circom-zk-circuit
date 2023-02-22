pragma circom 2.0.0;


template Main() {
  signal input x;
  signal input y;
  signal output prod;

  // Assign value and check equality
  // Constraint must be in quadratic form
  // prod <== x * y;
  
  // Above is equivalent to:
  // Assign value
  prod <-- x * y;
  // Check equality
  prod === x * y;
}

component main = Main();