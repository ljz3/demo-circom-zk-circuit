## Overview
This repository is a demo of a ZK circuit using Circom for self-learning purposes.

Code is written with material from zku.ONE

## Dependencies setup
### Install Rust
`curl --proto '=https' --tlsv1.2 [https://sh.rustup.rs](https://sh.rustup.rs/) -sSf | sh`

### Build Circom from source
`git clone [https://github.com/iden3/circom.git](https://github.com/iden3/circom.git)`

`cd circom`

`cargo build --release`

`cargo install --path circom`

### Install snarkjs
`yarn global add snarkjs`

## Usage
Note: Below are instructions for running the code with Node.js on a Windows machine. If you are using a Unix system, consider using the makefile inside the circuit_cpp directory after building for a faster runtime.

Below are the commands to run and verify the circuit in powershell/command prompt

1. Removes all of the generated files from previous runs:

    `rm circuit.r1cs`

    `rm circuit.sym`

    `rm circuit_*`

    `rm -r circuit_*`

    `rm pot*`

    `rm proof.json`

    `rm public.json`

    `rm verifier.sol`

    `rm verification_key.json`

    `rm witness.wtns`

    `rm parameters.txt`

2. Compiles the circom circuit to get a system of arithmetic equations representing the circuit

    --r1cs generates a file that contains the rlcs constraint system of circuit in binary format

    --wasm generates wasm code that can be used to generate the witness

    --c generates c code that can be used to generate witness

    --sym generates symbols file that can be used for debugging

    `circom circuit.circom --r1cs --wasm --sym --c`

3. Generate witness using Node.js

    `cd circuit_js`

    `node generate_witness.js circuit.wasm ../input.json witness.wtns`

4. Move the witness to the root directory

    `cp witness.wtns ../witness.wtns`

    `cd ..`

5. Use snarkjs to generate and validate a proof. The groth16 zk-snark protocol requires a trusted setup for each circuit which consists of:

    a. Create new powersoftau ceremony

        `snarkjs powersoftau new bn128 12 pot12_0000.ptau -v`
    
    b. Contribute to the created ceremony

        `snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v -e="some random text"`

    c. Prepare for start of phase 2

        `snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v`

    d. Generate zkey file that contains the proving and verification keys together with phase 2 contributions

        `snarkjs groth16 setup circuit.r1cs pot12_final.ptau circuit_0000.zkey`

        `snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="First contributor name" -v -e="some random text"`

    e. Export verification key to json file

        `snarkjs zkey export verificationkey circuit_0001.zkey verification_key.json`

6. Generate a zero knowledge proof using the zkey and witness. This outputs a proof file and a public file containing public inputs and outputs

    `snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json`

7. Use the verification key, proof and public file to verify if the proof is valid

    `snarkjs groth16 verify verification_key.json public.json proof.json`
